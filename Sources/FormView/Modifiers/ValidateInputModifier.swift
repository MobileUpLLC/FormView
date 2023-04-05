//
//  ValidateInputModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

struct ValidateInputModifier<Value: Equatable, Rule: ValidationRule>: ViewModifier where Value == Rule.Value {
    @ObservedObject private var validator: Validator<Value, Rule>
    @FocusState private var isFocused: Bool
    @Binding private var value: Value
    
    init(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self._value = value
        self.validator = Validator(
            validationRules: validationRules,
            failedValidationRules: failedValidationRules
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { newValue in
                validator.validate(value: newValue)
            }
            .focused($isFocused)
            .onChange(of: isFocused) { _ in
                validator.validate(value: value)
            }
            .onAppear {
                validator.validate(value: value)
            }
    }
}

extension View {
    func validateInput<Value: Equatable, Rule: ValidationRule>(
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
