//
//  TextValidationRule.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import Foundation

public struct TextValidationRule: ValidationRule {
    public let message: String
    
    private let checkClosure: (String) -> Bool
    
    public init(message: String, checkClosure: @escaping (String) -> Bool) {
        self.checkClosure = checkClosure
        self.message = message
    }
    
    public func check(value: String) -> Bool {
        return checkClosure(value)
    }
}

extension TextValidationRule {
    public static func notEmpty(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.isEmpty == false
        }
    }
    
    public static func atLeastOneLowercaseLetter(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
        }
    }
    
    public static func atLeastOneUppercaseLetter(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
        }
    }
    
    public static func atLeastOneDigit(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        }
    }
    
    public static func atLeastOneLetter(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.rangeOfCharacter(from: CharacterSet.letters) != nil
        }
    }
    
    public static func digitsOnly(message: String) -> Self {
        TextValidationRule(message: message) {
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0))
        }
    }
    
    public static func lettersOnly(message: String) -> Self {
        TextValidationRule(message: message) {
            CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: $0))
        }
    }
    
    public static func atLeastOneSpecialCharacter(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) != nil
        }
    }
    
    public static func noSpecialCharacters(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) == nil
        }
    }
    
    public static func email(message: String) -> Self {
        TextValidationRule(message: message) {
            NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                .evaluate(with: $0)
        }
    }
    
    public static func notRecurringPincode(message: String) -> Self {
        TextValidationRule(message: message) {
            $0.range(of: "([0-9])\\1\\1\\1", options: .regularExpression) == nil
        }
    }
    
    public static func minLength(count: Int, message: String) -> Self {
        TextValidationRule(message: message) {
            $0.count >= count
        }
    }
    
    public static func maxLength(count: Int, message: String) -> Self {
        TextValidationRule(message: message) {
            $0.count <= count
        }
    }
    
    public static func regex(value: String, message: String) -> Self {
        TextValidationRule(message: message) {
            NSPredicate(format: "SELF MATCHES %@", value)
                .evaluate(with: $0)
        }
    }
    
    public static func equalTo(value: String, message: String) -> Self {
        TextValidationRule(message: message) {
            $0 == value
        }
    }
}
