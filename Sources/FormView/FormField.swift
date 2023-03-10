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
    private var title: LocalizedStringKey
    
    @ObservedObject private var validator: Validator<String, TextValidationRule>
    
    @FocusState private var isFocused: Bool
    @Binding private var isSecure: Bool
    @State private var securedText: String = ""
    @State private var textLength: Int = 0
    
    public init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        validationRules: [TextValidationRule] = [],
        inputRules: [TextValidationRule] = [],
        failedValidationRules: Binding<[TextValidationRule]>? = nil,
        isSecure: Binding<Bool> = .constant(false)
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
    }
    
    public var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $validator.value)
            } else {
                TextField(title, text: $validator.value)
            }
        }
        .focused($isFocused)
        .onChange(of: validator.value) { [oldValue = validator.value] newValue in
            if validator.validateInput(newValue: newValue).isEmpty {
                validator.value = newValue
            } else {
                validator.value = oldValue
            }
            
            updateSecureText(with: newValue)
        }
        .onChange(of: focusField) { newValue in
            isFocused = newValue.trimmingCharacters(in: .whitespaces) == id
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
    
    private func updateSecureText(with newValue: String) {
        // При смене фокуса SecureField удаляет ранее введенный текст.
        // Чтобы текст сохранялся нужно определить было ли нажато удаление или добавление нового символа
        // и выполнить перезапись обновленного текста в модель.
        let isCharRemoved = textLength > 0 && textLength - newValue.count == textLength
        let isCharAdded = textLength > 0 && textLength - newValue.count > 1
        
        if isCharRemoved {
            securedText.removeLast()
            validator.value = securedText
        } else if isCharAdded {
            validator.value = securedText + newValue
        } else {
            securedText = newValue
        }
        
        textLength = newValue.count
    }
}
