//
//  ValidationRule.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import Foundation
import SwiftUI

public class ValidationRule {
    public var message: String
    public let isExternal: Bool
    public let conditions: [ValidationBehaviour]
    
    private let checkClosure: (String) async -> (Bool, String)
    
    internal required init(
        conditions: [ValidationBehaviour],
        isExternal: Bool,
        checkClosure: @escaping (String) async -> (Bool, String)
    ) {
        self.message = .empty
        self.checkClosure = checkClosure
        self.isExternal = isExternal
        self.conditions = conditions
    }
    
    public func check(value: String) async -> Bool {
        let (result, message) = await checkClosure(value)
        self.message = message
        
        return result
    }
}

extension ValidationRule {
    public static func custom(
        conditions: [ValidationBehaviour],
        checkClosure: @escaping (String) async -> (Bool, String)
    ) -> Self {
        return Self(conditions: conditions, isExternal: false, checkClosure: checkClosure)
    }
    
    public static func external(checkClosure: @escaping (String) async -> (Bool, String)) -> Self {
        return Self(conditions: [.manual], isExternal: true, checkClosure: checkClosure)
    }
    
    public static func notEmpty(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.isEmpty == false, message)
        }
    }
    
    public static func atLeastOneLowercaseLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil, message)
        }
    }
    
    public static func atLeastOneUppercaseLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil, message)
        }
    }
    
    public static func atLeastOneDigit(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil, message)
        }
    }
    
    public static func atLeastOneLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.rangeOfCharacter(from: CharacterSet.letters) != nil, message)
        }
    }
    
    public static func digitsOnly(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return (CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0)), message)
        }
    }
    
    public static func lettersOnly(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return (CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: $0)), message)
        }
    }
    
    public static func atLeastOneSpecialCharacter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) != nil, message)
        }
    }
    
    public static func noSpecialCharacters(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) == nil, message)
        }
    }
    
    public static func email(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return (
                NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                    .evaluate(with: $0),
                message
            )
        }
    }
    
    public static func notRecurringPincode(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.range(of: "([0-9])\\1\\1\\1", options: .regularExpression) == nil, message)
        }
    }
    
    public static func minLength(conditions: [ValidationBehaviour], count: Int, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.count >= count, message)
        }
    }
    
    public static func maxLength(conditions: [ValidationBehaviour], count: Int, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return ($0.count <= count, message)
        }
    }
    
    public static func regex(conditions: [ValidationBehaviour], value: String, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return (NSPredicate(format: "SELF MATCHES %@", value).evaluate(with: $0), message)
        }
    }
}
