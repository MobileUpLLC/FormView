//
//  Validator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

final class Validator<Value: Hashable, Rule: ValidationRule>: ObservableObject where Value == Rule.Value {
    @Binding private var bindValue: Value
    private var bindFailedValidationRules: Binding<[Rule]>?
    private let validationRules: [Rule]
    
    @Published var value: Value {
        willSet { validate(newValue: newValue) }
        didSet { bindValue = value }
    }
    
    init(
        value: Binding<Value>,
        validationRules: [Rule],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self.validationRules = validationRules
        self._bindValue = value
        self.bindFailedValidationRules = failedValidationRules
        self.value = value.wrappedValue
    }
    
    func validate(newValue: Value? = nil) {
        let failedValidationRules = validationRules.filter {
            $0.check(value: newValue ?? value) == false
        }
        bindFailedValidationRules?.wrappedValue = failedValidationRules
    }
}
