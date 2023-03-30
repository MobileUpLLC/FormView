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
    @ViewBuilder private let content: ([V]) -> Content
    
    @State private var failedValidationRules: [V] = []
    
    public init(
        value: Binding<T>,
        validationRules: [V] = [],
        @ViewBuilder content: @escaping ([V]) -> Content
    ) {
        self._bindValue = value
        self.validationRules = validationRules
        self.content = content
    }
    
    public var body: some View {
        content(failedValidationRules)
            .formField(
                value: $bindValue,
                validationRules: validationRules,
                failedValidationRules: $failedValidationRules
            )
    }
}
