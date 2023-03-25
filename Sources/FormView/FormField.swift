//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

public struct FormField<T: Hashable, V: ValidationRule, Content: View>: View where T == V.Value {
    
    @Binding private var bindValue: T
    private let validationRules: [V]
    private let inputRules: [V]
    private var bindFailedValidationRules: Binding<[V]>?
    @ViewBuilder private let content: Content
    
    public init(
        value: Binding<T>,
        validationRules: [V] = [],
        inputRules: [V] = [],
        failedValidationRules: Binding<[V]>? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._bindValue = value
        self.validationRules = validationRules
        self.inputRules = inputRules
        self.bindFailedValidationRules = failedValidationRules
        self.content = content()
    }
    
    public var body: some View {
        content
            .formField(
                value: $bindValue,
                validationRules: validationRules,
                inputRules: inputRules,
                failedValidationRules: bindFailedValidationRules
            )
    }
}
