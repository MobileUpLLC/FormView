//
//  ValidateInputModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

enum ErrorHideBehaviour {
    case onValueChanged
    case onFocus
    case onFocusLost
}

struct ValidateInputModifier<Value: Equatable, Rule: ValidationRule>: ViewModifier where Value == Rule.Value {
    @Binding private var value: Value
    @FocusState private var isFocused: Bool
    @ObservedObject private var validator: FieldValidator<Value, Rule>
    
    private let errorHideBehaviour: ErrorHideBehaviour = .onValueChanged
    private let validationBehaviour: ValidationBehaviour = .never
    
    init(
        value: Binding<Value>,
        validationRules: [Rule] = [],
        failedValidationRules: Binding<[Rule]>? = nil
    ) {
        self._value = value
        self.validator = FieldValidator(
            validationRules: validationRules,
            failedValidationRules: failedValidationRules
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { newValue in
                if errorHideBehaviour == .onValueChanged {
//                    validator.reset()
                }
                
                if validationBehaviour == .onFieldValueChanged {
                    validator.validate(value: newValue)
                }
            }
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                if errorHideBehaviour == .onFocusLost && newValue == false {
//                    validator.reset()
                } else if errorHideBehaviour == .onFocus && newValue == true {
//                    validator.reset()
                }
                
                if validationBehaviour == .onFieldFocusLost && newValue == false {
                    validator.validate(value: value)
                }
            }
//            .onAppear {
//                validator.validate(value: value)
//            }
    }
}

//extension View {
//    func validateInput<Value: Equatable, Rule: ValidationRule>(
//        value: Binding<Value>,
//        validationRules: [Rule] = [],
//        failedValidationRules: Binding<[Rule]>? = nil
//    ) -> some View where Value == Rule.Value {
//        modifier(
//            ValidateInputModifier(
//                value: value,
//                validationRules: validationRules,
//                failedValidationRules: failedValidationRules
//            )
//        )
//    }
//}
