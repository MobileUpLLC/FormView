//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

public struct FormField<Value: Hashable, Rule: ValidationRule, Content: View>: View where Value == Rule.Value {
    @Binding private var value: Value
    private let validationRules: [Rule]
    @ViewBuilder private let content: ([Rule]) -> Content
    
    @State private var failedValidationRules: [Rule] = []
    
    public init(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        @ViewBuilder content: @escaping ([Rule]) -> Content
    ) {
        self._value = value
        self.validationRules = validationRules
        self.content = content
    }
    
    public var body: some View {
        content(failedValidationRules)
            .modifier(JumpOnSubmitModifier())
            .modifier(
                ValidateInputModifier(
                    value: $value,
                    validationRules: validationRules,
                    failedValidationRules: $failedValidationRules
                )
            )
    }
}
