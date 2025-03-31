//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

public struct FormField<Content: View>: View {
    @Binding private var value: String
    @ViewBuilder private let content: ([ValidationRule]) -> Content
    
    @State private var failedValidationRules: [ValidationRule] = []
    private var isValid: Bool { failedValidationRules.isEmpty && value.isEmpty == false }
    
    // Fields Focus
    @FocusState private var isFocused: Bool
    @State private var id: String = UUID().uuidString
    @Environment(\.focusedFieldId) var currentFocusedFieldId
    
    // ValidateInput
    private let validator: FieldValidator
    @Environment(\.errorHideBehaviour) var errorHideBehaviour
    @Environment(\.validationBehaviour) var validationBehaviour
    
    public init(
        value: Binding<String>,
        rules: [ValidationRule] = [],
        @ViewBuilder content: @escaping ([ValidationRule]) -> Content
    ) {
        self._value = value
        self.content = content
        self.validator = FieldValidator(rules: rules)
    }
    
    public var body: some View {
        content(failedValidationRules)
        // Fields Focus
            .onChange(of: currentFocusedFieldId) { newValue in
                DispatchQueue.main.async {
                    isFocused = newValue.trimmingCharacters(in: .whitespaces) == id
                }
            }
            .preference(
                key: FieldStatesKey.self,
                value: [
                    // Замыкание для каждого филда вызывается FormValidator'ом из FormView для валидации по требованию
                    FieldState(id: id, isFocused: isFocused) {
                        let failedRules = await validator.validate(
                            value: value,
                            condition: .manual,
                            isNeedToCheckExternal: true
                        )
                        failedValidationRules = failedRules
                        
                        return failedRules.isEmpty
                    }
                ]
            )
            .preference(key: FieldsValidationKey.self, value: [isValid])
            .focused($isFocused)
        
        // Fields Validation
            .onChange(of: value) { newValue in
                Task { @MainActor in
                    if errorHideBehaviour == .onValueChanged {
                        failedValidationRules = .empty
                    }
                    
                    if validationBehaviour.contains(.onFieldValueChanged) {
                        failedValidationRules = await validator.validate(
                            value: newValue,
                            condition: .onFieldValueChanged,
                            isNeedToCheckExternal: false
                        )
                    }
                }
            }
            .onChange(of: isFocused) { newValue in
                Task { @MainActor in
                    if errorHideBehaviour == .onFocusLost && newValue == false {
                        failedValidationRules = .empty
                    } else if errorHideBehaviour == .onFocus && newValue == true {
                        failedValidationRules = .empty
                    }
                    
                    if validationBehaviour.contains(.onFieldFocusLost) && newValue == false {
                        failedValidationRules = await validator.validate(
                            value: value,
                            condition: .onFieldFocusLost,
                            isNeedToCheckExternal: false
                        )
                    }
                    
                    if
                        validationBehaviour.contains(.onFieldFocus)
                        && failedValidationRules.isEmpty
                        && newValue == true
                    {
                        failedValidationRules = await validator.validate(
                            value: value,
                            condition: .onFieldFocus,
                            isNeedToCheckExternal: false
                        )
                    }
                }
            }
    }
}
