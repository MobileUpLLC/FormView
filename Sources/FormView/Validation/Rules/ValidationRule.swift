//
//  ValidationRule.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import Foundation
import SwiftUI

public class ValidationRule {
    public var message: String?
    public let isExternal: Bool
    
    private let checkClosure: (String) async -> String?
    
    internal required init(isExternal: Bool, checkClosure: @escaping (String) async -> String?) {
        self.checkClosure = checkClosure
        self.isExternal = isExternal
    }
    
    public func check(value: String) async -> Bool {
        let message = await checkClosure(value)
        self.message = message
        
        return message == nil
    }
}

extension ValidationRule {
    public static func custom(checkClosure: @escaping (String) async -> String?) -> Self {
        return Self(isExternal: false, checkClosure: checkClosure)
    }
    
    public static func external(checkClosure: @escaping (String) async -> String?) -> Self {
        return Self(isExternal: true, checkClosure: checkClosure)
    }
    
    public static func notEmpty(message: String) -> Self {
        return Self(isExternal: false) {
            return $0.isEmpty == false ? nil : message
        }
    }
    
    public static func atLeastOneLowercaseLetter(message: String) -> Self {
        return Self(isExternal: false) {
            return $0.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil ? nil : message
        }
    }
    
    public static func atLeastOneUppercaseLetter(message: String) -> Self {
        return Self(isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil ? nil : message
        }
    }
    
    public static func atLeastOneDigit(message: String) -> Self {
        return Self(isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil ? nil : message
        }
    }
    
    public static func atLeastOneLetter(message: String) -> Self {
        return Self(isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.letters) != nil ? nil : message
        }
    }
    
    public static func digitsOnly(message: String) -> Self {
        return Self(isExternal: false) {
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0)) ? nil : message
        }
    }
    
    public static func lettersOnly(message: String) -> Self {
        return Self(isExternal: false) {
            CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: $0)) ? nil : message
        }
    }
    
    public static func atLeastOneSpecialCharacter(message: String) -> Self {
        return Self(isExternal: false) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) != nil ? nil : message
        }
    }
    
    public static func noSpecialCharacters(message: String) -> Self {
        return Self(isExternal: false) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) == nil ? nil : message
        }
    }
    
    public static func email(message: String) -> Self {
        return Self(isExternal: false) {
            NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                .evaluate(with: $0) ? nil : message
        }
    }
    
    public static func notRecurringPincode(message: String) -> Self {
        return Self(isExternal: false) {
            $0.range(of: "([0-9])\\1\\1\\1", options: .regularExpression) == nil ? nil : message
        }
    }
    
    public static func minLength(count: Int, message: String) -> Self {
        return Self(isExternal: false) {
            $0.count >= count ? nil : message
        }
    }
    
    public static func maxLength(count: Int, message: String) -> Self {
        return Self(isExternal: false) {
            $0.count <= count ? nil : message
        }
    }
    
    public static func regex(value: String, message: String) -> Self {
        return Self(isExternal: false) {
            NSPredicate(format: "SELF MATCHES %@", value)
                .evaluate(with: $0) ? nil : message
        }
    }
}
