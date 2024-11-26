//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

class FormFieldStateHandler<Value: Hashable, Rule: ValidationRule>: ObservableObject {
    @Published var failedValidationRules: [Rule] = []
    
    var id: String = UUID().uuidString
    
    private var value: Value
    private var isFocused: Bool = false
    private let validator: FieldValidator<Rule>
    
    init(value: Value, failedValidationRules: [Rule]) {
        self.value = value
        self.failedValidationRules = failedValidationRules
        self.validator = FieldValidator(rules: failedValidationRules)
    }
    
    func updateValue(newValue: Value) {
        value = newValue
    }
    
    func updateIsFocused(newValue: Bool) {
        isFocused = newValue
    }
    
    func updateRule() {
        if let value = value as? Rule.Value {
            failedValidationRules = validator.validate(value: value)
        }
    }
    
    func getFieldState() -> FieldState {
        return FieldState(id: id, isFocused: isFocused) { [weak self] in
            guard
                let self,
                let value = self.value as? Rule.Value
            else {
                return true
            }
            
            print("value \(value)")
            
            let failedRules = validator.validate(value: value)
            failedValidationRules = failedRules
            
            return failedRules.isEmpty
        }
    }
}

public struct FormField<Value: Hashable, Rule: ValidationRule, Content: View>: View where Value == Rule.Value {
    @StateObject var fromStateHandler: FormFieldStateHandler<Value, Rule>
    @Binding private var value: Value
    @ViewBuilder private let content: ([Rule]) -> Content
    
    // Fields Focus
    @FocusState private var isFocused: Bool
//    @State private var id: String = UUID().uuidString
    @Environment(\.focusedFieldId) var currentFocusedFieldId
    
    // ValidateInput
    @Environment(\.errorHideBehaviour) var errorHideBehaviour
    @Environment(\.validationBehaviour) var validationBehaviour
    
    public init(
        value: Binding<Value>,
        rules: [Rule] = [],
        @ViewBuilder content: @escaping ([Rule]) -> Content
    ) {
        self._value = value
        self.content = content
        self._fromStateHandler = StateObject(wrappedValue: FormFieldStateHandler<Value, Rule>(value: value.wrappedValue, failedValidationRules: rules))
    }
    
    public var body: some View {
        content(fromStateHandler.failedValidationRules)
        // Fields Focus
            .onChange(of: currentFocusedFieldId) { newValue in
                DispatchQueue.main.async {
                    isFocused = newValue.trimmingCharacters(in: .whitespaces) == fromStateHandler.id
                }
            }
            .preference(
                key: FieldStatesKey.self,
                value: [
                    // Замыкание для каждого филда вызывается FormValidator'ом из FormView для валидации по требованию
                    fromStateHandler.getFieldState()
                ]
            )
            .focused($isFocused)
        
        // Fields Validation
            .onChange(of: value) { newValue in
                fromStateHandler.updateValue(newValue: newValue)
                
                if errorHideBehaviour == .onValueChanged {
                    fromStateHandler.failedValidationRules = .empty
                    print("==--== 1")
                }
                
                if validationBehaviour == .onFieldValueChanged {
                    fromStateHandler.updateRule()
                    print("==--== 2")
                }
            }
            .onChange(of: isFocused) { newValue in
                fromStateHandler.updateIsFocused(newValue: newValue)
                
                if errorHideBehaviour == .onFocusLost && newValue == false {
                    fromStateHandler.failedValidationRules = .empty
                    print("==--== 3")
                } else if errorHideBehaviour == .onFocus && newValue == true {
                    fromStateHandler.failedValidationRules = .empty
                    print("==--== 4")
                }
                
                if validationBehaviour == .onFieldFocusLost && newValue == false {
                    fromStateHandler.updateRule()
                    print("==--== 5")
                }
            }
    }
}
