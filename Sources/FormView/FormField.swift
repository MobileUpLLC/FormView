//
//  FormField.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

public struct FormField: View {
    
    @Environment(\.focusField) var focusField
    
    private let id: String
    private let isMultiline: Bool
    private var title: LocalizedStringKey
    
    @ObservedObject private var validator: Validator<String, TextValidationRule>
    
    @FocusState private var isFocused: Bool
    @Binding private var isSecure: Bool
    @State private var securedText: String = ""
    @State private var textLength: Int = 0
    @State private var focusChangeCounter = 0
    @State private var lastSecureFocusCounter = 0
    
    public init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        validationRules: [TextValidationRule] = [],
        inputRules: [TextValidationRule] = [],
        failedValidationRules: Binding<[TextValidationRule]>? = nil,
        isSecure: Binding<Bool> = .constant(false),
        isMultiline: Bool = false
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.validator = Validator(
            value: text,
            validationRules: validationRules,
            inputRules: inputRules,
            failedValidationRules: failedValidationRules
        )
        self._isSecure = isSecure
        self.isMultiline = isMultiline
    }
    
    public var body: some View {
        Group {
            if isMultiline {
                TextEditor(text: $validator.value)
            } else {
                if isSecure {
                    SecureField(title, text: $validator.value)
                } else {
                    TextField(title, text: $validator.value)
                }
            }
        }
        .focused($isFocused)
        .onChange(of: validator.value) { [oldValue = validator.value] newValue in
            if validator.validateInput(newValue: newValue).isEmpty {
                validator.value = newValue
            } else {
                validator.value = oldValue
            }
            
            updateSecureText(with: newValue, isSecure: isSecure)
        }
        .onChange(of: focusField) { newValue in
            isFocused = newValue.trimmingCharacters(in: .whitespaces) == id
        }
        .onChange(of: isFocused) { newValue in
            focusChangeCounter += 1
        }
        .onAppear {
            validator.validate()
        }
        .preference(
            key: FieldStatesKey.self,
            value: [
                FieldState(id: id, isFocused: isFocused)
            ]
        )
    }
    
    private func updateSecureText(with newValue: String, isSecure: Bool) {
        if isSecure == false {
            securedText = newValue
            textLength = newValue.count
            
            return
        }
        
        // При смене фокуса SecureField удаляет ранее введенный текст.
        // Чтобы текст сохранялся нужно определить было ли нажато удаление или добавление нового символа
        // и выполнить перезапись обновленного текста в модель.
        let isCharRemoved = lastSecureFocusCounter == focusChangeCounter
            ? textLength > 0 && textLength > newValue.count
            : textLength > 0 && textLength - newValue.count == textLength
        
        let isCharAdded = textLength > 0 && textLength - newValue.count > 1
        
        if isCharRemoved {
            securedText = newValue
            validator.value = securedText
        } else if isCharAdded {
            validator.value = securedText + newValue
        } else {
            securedText = newValue
        }
        
        lastSecureFocusCounter = focusChangeCounter
        textLength = newValue.count
    }
}
