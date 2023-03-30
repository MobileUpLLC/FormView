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
    private var bindFailedValidationRules: Binding<[V]>?
    
    init(
        value: Binding<T>,
        validationRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) {
        self._bindValue = value
        self.validationRules = validationRules
        self.bindFailedValidationRules = failedValidationRules
    }
    
    func body(content: Content) -> some View {
        content
            .jumpOnSubmit()
            .validateInput(
                value: $bindValue,
                validationRules: validationRules,
                failedValidationRules: bindFailedValidationRules
            )
    }
}

extension View {
    
    func formField<T: Hashable, V: ValidationRule>(
        value: Binding<T>,
        validationRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil
    ) -> some View where T == V.Value {
        modifier(
            FormFieldModifier(
                value: value,
                validationRules: validationRules,
                failedValidationRules: failedValidationRules
            )
        )
    }
}
