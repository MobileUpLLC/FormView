//
//  TextValidationRule.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import Foundation

public struct TextValidationRule: ValidationRule {
    private let checkClosure: (String) -> Bool
    public let id: UUID = UUID()
    
    public init(_ checkClosure: @escaping (String) -> Bool) {
        self.checkClosure = checkClosure
    }
    
    public func check(value: String) -> Bool {
        return checkClosure(value)
    }
}

extension TextValidationRule {
    public static var notEmpty: Self {
        TextValidationRule {
            $0.isEmpty == false
        }
    }
    
    public static var atLeastOneLowercaseLetter: Self {
        TextValidationRule {
            $0.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
        }
    }
    
    public static var atLeastOneUppercaseLetter: Self {
        TextValidationRule {
            $0.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
        }
    }
    
    public static var atLeastOneDigit: Self {
        TextValidationRule {
            $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        }
    }
    
    public static var atLeastOneLetter: Self {
        TextValidationRule {
            $0.rangeOfCharacter(from: CharacterSet.letters) != nil
        }
    }
    
    public static var digitsOnly: Self {
        TextValidationRule {
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0))
        }
    }
    
    public static var lettersOnly: Self {
        TextValidationRule {
            CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: $0))
        }
    }
    
    public static var atLeastOneSpecialCharacter: Self {
        TextValidationRule {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) != nil
        }
    }
    
    public static var noSpecialCharacters: Self {
        TextValidationRule {
            $0.range(of: ".*[^A-Za-zА-Яа-яё0-9 ].*", options: .regularExpression) == nil
        }
    }
    
    public static var email: Self {
        TextValidationRule {
            NSPredicate(
                format: "SELF MATCHES %@",
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            ).evaluate(with: $0)
        }
    }
    
    public static var notRecurringPincode: Self {
        TextValidationRule {
            $0.range(of: "([0-9])\\1\\1\\1", options: .regularExpression) == nil
        }
    }
    
    public static func minLength(_ count: Int) -> Self {
        TextValidationRule {
            $0.count >= count
        }
    }
    
    public static func maxLength(_ count: Int) -> Self {
        TextValidationRule {
            $0.count <= count
        }
    }
    
    public static func regex(_ regex: String) -> Self {
        TextValidationRule {
            NSPredicate(
                format: "SELF MATCHES %@",
                regex
            ).evaluate(with: $0)
        }
    }
    
    public static func equalTo(_ string: String) -> Self {
        TextValidationRule {
            $0 == string
        }
    }
}
