//
//  ValidateInputModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

struct ValidateInputModifier<T: Hashable, V: ValidationRule>: ViewModifier where T == V.Value {
    
    @ObservedObject private var validator: Validator<T, V>
    
    @FocusState private var isFocused: Bool
    
    init(
        value: Binding<T>,
        validationRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
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
            .onChange(of: isFocused) { newValue in
                validator.validate()
            }
            .onAppear {
                validator.validate()
            }
    }
}

extension View {
    
    func validateInput<T: Hashable, V: ValidationRule>(
        value: Binding<T>,
        validationRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) -> some View where T == V.Value {
        modifier(
            ValidateInputModifier(
                value: value,
                validationRules: validationRules,
                failedValidationRules: failedValidationRules
            )
        )
    }
}
