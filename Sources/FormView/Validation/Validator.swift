//
//  Validator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

final class Validator<Value: Equatable, Rule: ValidationRule>: ObservableObject where Value == Rule.Value {
    private let validationRules: [Rule]
    private var bindFailedValidationRules: Binding<[Rule]>?
    
    init(
        validationRules: [Rule],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self.validationRules = validationRules
        self.bindFailedValidationRules = failedValidationRules
    }
    
    func validate(value: Value) {
        let failedValidationRules = validationRules.filter {
            $0.check(value: value) == false
        }
        bindFailedValidationRules?.wrappedValue = failedValidationRules
    }
}
