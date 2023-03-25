//
//  FormFieldModifier.swift
//  
//
//  Created by Maxim Aliev on 25.03.2023.
//

import SwiftUI

struct FormFieldModifier<T: Hashable, V: ValidationRule>: ViewModifier where T == V.Value {
    
    @Binding private var bindValue: T
    private let validationRules: [V]
    private let inputRules: [V]
    private var bindFailedValidationRules: Binding<[V]>?
    
    public init(
        value: Binding<T>,
        validationRules: [V] = [],
        inputRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) {
        self._bindValue = value
        self.validationRules = validationRules
        self.inputRules = inputRules
        self.bindFailedValidationRules = failedValidationRules
    }
    
    func body(content: Content) -> some View {
        content
            .jumpOnSubmit()
            .validateInput(
                value: $bindValue,
                validationRules: validationRules,
                inputRules: inputRules,
                failedValidationRules: bindFailedValidationRules
            )
    }
}

extension View {
    
    public func formField<T: Hashable, V: ValidationRule>(
        value: Binding<T>,
        validationRules: [V] = [],
        inputRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) -> some View where T == V.Value {
        modifier(
            FormFieldModifier(
                value: value,
                validationRules: validationRules,
                inputRules: inputRules,
                failedValidationRules: failedValidationRules
            )
        )
    }
}
