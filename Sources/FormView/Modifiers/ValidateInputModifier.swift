//
//  ValidateInputModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

struct ValidateInputModifier<Value: Hashable, Rule: ValidationRule>: ViewModifier where Value == Rule.Value {
    @ObservedObject private var validator: Validator<Value, Rule>
    
    @FocusState private var isFocused: Bool
    
    init(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self.validator = Validator(
            value: value,
            validationRules: validationRules,
            failedValidationRules: failedValidationRules
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: validator.value) { newValue in
                validator.validate(newValue: newValue)
            }
            .focused($isFocused)
            .onChange(of: isFocused) { _ in
                validator.validate()
            }
            .onAppear {
                validator.validate()
            }
    }
}

extension View {
    func validateInput<Value: Hashable, Rule: ValidationRule>(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        failedValidationRules: Binding<[Rule]>? = nil
    ) -> some View where Value == Rule.Value {
        modifier(
            ValidateInputModifier(
                value: value,
                validationRules: validationRules,
                failedValidationRules: failedValidationRules
            )
        )
    }
}
