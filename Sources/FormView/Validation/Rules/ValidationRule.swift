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
    
    private let checkClosure: (String) async -> (String, Bool)
    
    internal required init(
        conditions: [ValidationBehaviour],
        isExternal: Bool,
        checkClosure: @escaping (String) async -> (String, Bool)
    ) {
        self.message = .empty
        self.checkClosure = checkClosure
        self.isExternal = isExternal
        self.conditions = conditions
    }
    
    public func check(value: String) async -> Bool {
        let checkResult = await checkClosure(value)
        let message = checkResult.0
        self.message = message
        
        return checkResult.1
    }
}

extension ValidationRule {
    public static func custom(
        conditions: [ValidationBehaviour],
        checkClosure: @escaping (String) async -> (String, Bool)
    ) -> Self {
        return Self(conditions: conditions, isExternal: false, checkClosure: checkClosure)
    }
    
    public static func external(checkClosure: @escaping (String) async -> (String, Bool)) -> Self {
        return Self(conditions: [.manual], isExternal: true, checkClosure: checkClosure)
    }
    
    public static func notEmpty(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return $0.isEmpty == false ? (message, true) : (message, false)
        }
    }
    
    public static func atLeastOneLowercaseLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            return $0.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil ? (message, true) : (message, false)
        }
    }
    
    public static func atLeastOneUppercaseLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil ? (message, true) : (message, false)
        }
    }
    
    public static func atLeastOneDigit(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil ? (message, true) : (message, false)
        }
    }
    
    public static func atLeastOneLetter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.rangeOfCharacter(from: CharacterSet.letters) != nil ? (message, true) : (message, false)
        }
    }
    
    public static func digitsOnly(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0))
                ? (message, true)
                : (message, false)
        }
    }
    
    public static func lettersOnly(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: $0)) ? (message, true) : (message, false)
        }
    }
    
    public static func atLeastOneSpecialCharacter(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) != nil
                ? (message, true)
                : (message, false)
        }
    }
    
    public static func noSpecialCharacters(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) == nil
                ? (message, true)
                : (message, false)
        }
    }
    
    public static func email(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                .evaluate(with: $0) ? (message, true) : (message, false)
        }
    }
    
    public static func notRecurringPincode(conditions: [ValidationBehaviour], message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.range(of: "([0-9])\\1\\1\\1", options: .regularExpression) == nil ? (message, true) : (message, false)
        }
    }
    
    public static func minLength(conditions: [ValidationBehaviour], count: Int, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.count >= count ? (message, true) : (message, false)
        }
    }
    
    public static func maxLength(conditions: [ValidationBehaviour], count: Int, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            $0.count <= count ? (message, true) : (message, false)
        }
    }
    
    public static func regex(conditions: [ValidationBehaviour], value: String, message: String) -> Self {
        return Self(conditions: conditions, isExternal: false) {
            NSPredicate(format: "SELF MATCHES %@", value)
                .evaluate(with: $0) ? (message, true) : (message, false)
        }
    }
}
