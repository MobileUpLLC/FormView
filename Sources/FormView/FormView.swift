//
//  FormView.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import SwiftUI

public enum ValidationBehaviour {
    case onFieldValueChanged
    case onFieldFocus
    case onFieldFocusLost
    case manual
}

public enum ErrorHideBehaviour {
    case onValueChanged
    case onFocus
    case onFocusLost
}

private class FormStateHandler: ObservableObject {
    @Published var fieldStates: [FieldState] = .empty
    @Published var currentFocusedFieldId: String = .empty
    var formValidator = FormValidator()
    
    func updateFieldStates(newStates: [FieldState]) {
        fieldStates = newStates
        
        let focusedField = newStates.first { $0.isFocused }
        currentFocusedFieldId = focusedField?.id ?? .empty
       
        // Замыкание onValidateRun вызывается методом validate() FormValidator'a.
        formValidator.onValidateRun = { @MainActor [weak self] focusOnFirstFailedField in
            guard let self else {
                return false
            }
            
            var results: [Bool] = []
            
            for newState in newStates {
                let result = await newState.onValidate()
                results.append(result)
            }
            
            // Фокус на первом зафейленом филде.
            if let index = results.firstIndex(of: false), focusOnFirstFailedField {
                currentFocusedFieldId = fieldStates[index].id
            }
               
            return results.allSatisfy { $0 }
        }
    }
    
    func submit() {
        currentFocusedFieldId = FocusService.getNextFocusFieldId(
            states: fieldStates,
            currentFocusField: currentFocusedFieldId
        )
    }
}

public struct FormView<Content: View>: View {
    @StateObject private var formStateHandler = FormStateHandler()
    @ViewBuilder private let content: (FormValidator) -> Content
    
    private let errorHideBehaviour: ErrorHideBehaviour
    private let validationBehaviour: [ValidationBehaviour]
    
    public init(
        validate: [ValidationBehaviour] = [.manual],
        hideError: ErrorHideBehaviour = .onValueChanged,
        @ViewBuilder content: @escaping (FormValidator) -> Content
    ) {
        self.content = content
        self.validationBehaviour = validate
        self.errorHideBehaviour = hideError
    }
    
    public var body: some View {
        return content(formStateHandler.formValidator)
            // [weak formStateHandler] необходимо для избежания захвата сильных ссылок между
            // замыканием и @StateObject
            .onPreferenceChange(FieldStatesKey.self) { [weak formStateHandler] newStates in
                formStateHandler?.updateFieldStates(newStates: newStates)
            }
            .onSubmit(of: .text) { [weak formStateHandler] in
                formStateHandler?.submit()
            }
            .environment(\.focusedFieldId, formStateHandler.currentFocusedFieldId)
            .environment(\.errorHideBehaviour, errorHideBehaviour)
            .environment(\.validationBehaviour, validationBehaviour)
    }
}
