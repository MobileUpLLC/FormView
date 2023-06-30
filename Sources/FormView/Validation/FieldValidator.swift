//
//  FieldValidator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

final class FieldValidator<Value: Equatable, Rule: ValidationRule>: ObservableObject where Value == Rule.Value {
    private let validationRules: [Rule]
    private var bindFailedValidationRules: Binding<[Rule]>?
    
    var isValid: Bool { bindFailedValidationRules?.wrappedValue.isEmpty ?? true }
    
    init(
        validationRules: [Rule],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self.validationRules = validationRules
        self.bindFailedValidationRules = failedValidationRules
    }
   
    @discardableResult
    func validate(value: Value) -> [Rule] {
        let failedValidationRules = validationRules.filter {
            $0.check(value: value) == false
        }
        bindFailedValidationRules?.wrappedValue = failedValidationRules
        
        return failedValidationRules
    }
    
//    func reset() {
//        bindFailedValidationRules?.wrappedValue = []
//    }
}


final class FieldValidator2<Value: Equatable, Rule: ValidationRule> where Value == Rule.Value {
    private let validationRules: [Rule]
    
    init(validationRules: [Rule]) {
        self.validationRules = validationRules
    }
   
    func validate(value: Value) -> [Rule] {
        return validationRules.filter {
            $0.check(value: value) == false
        }
    }
}
