//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

public struct FormField<Value: Hashable, Rule: ValidationRule, Content: View>: View where Value == Rule.Value {
    @Binding private var value: Value
    @ViewBuilder private let content: ([Rule]) -> Content
    
    @State private var failedValidationRules: [Rule] = []
    
    // JumpOnSubmit
    @FocusState private var isFocused: Bool
    private let id: String = UUID().uuidString
    @Environment(\.focusedFieldId) var currentFocusedFieldId
    
    // ValidateInput
    private let validator: FieldValidator2<Value, Rule>
    private let errorHideBehaviour: ErrorHideBehaviour = .onValueChanged
    private let validationBehaviour: ValidationBehaviour = .onFieldFocusLost
    
    public init(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        @ViewBuilder content: @escaping ([Rule]) -> Content
    ) {
        self._value = value
        self.content = content
        self.validator = FieldValidator2(validationRules: validationRules)
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
                key: FieldFocusStatesKey.self,
                value: [
                    // Замыкание вызывается FormValidator'ом из FormView для валидации по требованию
                    FieldFocusState(id: id, isFocused: isFocused) {
                        let failedRules = validator.validate(value: value)
                        print("Failed rules \(failedRules.count) for id: \(id)")
                        
                        failedValidationRules = failedRules
                        
                        return failedRules.isEmpty
                    }
                ]
            )
            .focused($isFocused)
        
        // Fields Validation
            .onChange(of: value) { newValue in
                if errorHideBehaviour == .onValueChanged {
                    failedValidationRules = .empty
                }
                
                if validationBehaviour == .onFieldValueChanged {
                    failedValidationRules = validator.validate(value: newValue)
                }
            }
            .onChange(of: isFocused) { newValue in
                if errorHideBehaviour == .onFocusLost && newValue == false {
                    failedValidationRules = .empty
                } else if errorHideBehaviour == .onFocus && newValue == true {
                    failedValidationRules = .empty
                }
                
                if validationBehaviour == .onFieldFocusLost && newValue == false {
                    failedValidationRules = validator.validate(value: value)
                }
            }
    }
}

extension Array {
    static var empty: Array { [] }
}
