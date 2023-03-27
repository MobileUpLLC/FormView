//
//  ValidateInputModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

public struct ValidateInputModifier<T: Hashable, V: ValidationRule>: ViewModifier where T == V.Value {
    
    @ObservedObject private var validator: Validator<T, V>
    
    @FocusState private var isFocused: Bool
    
    public init(
        value: Binding<T>,
        validationRules: [V] = [],
        inputRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) {
        self.validator = Validator(
            value: value,
            validationRules: validationRules,
            inputRules: inputRules,
            failedValidationRules: failedValidationRules
        )
    }
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: validator.value) { [oldValue = validator.value] newValue in
                validateInput(oldValue: oldValue, newValue: newValue)
            }
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                validator.validate()
            }
            .onAppear {
                validator.validate()
            }
    }
    
    private func validateInput(oldValue: T, newValue: T) {
        if validator.validateInput(newValue: newValue).isEmpty {
            validator.value = newValue
        } else {
            validator.value = oldValue
        }
    }
}

extension View {
    
    public func validateInput<T: Hashable, V: ValidationRule>(
        value: Binding<T>,
        validationRules: [V] = [],
        inputRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) -> some View where T == V.Value {
        modifier(
            ValidateInputModifier(
                value: value,
                validationRules: validationRules,
                inputRules: inputRules,
                failedValidationRules: failedValidationRules
            )
        )
    }
}
