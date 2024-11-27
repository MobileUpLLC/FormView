//
//  FormView.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import SwiftUI

public enum ValidationBehaviour {
    case onFieldValueChanged
    case onFieldFocusLost
    case never
}

public enum ErrorHideBehaviour {
    case onValueChanged
    case onFocus
    case onFocusLost
}

public struct FormView<Content: View>: View {
    @StateObject private var formStateHandler = FormStateHandler()
    @ViewBuilder private let content: (FormValidator) -> Content
    
    private let errorHideBehaviour: ErrorHideBehaviour
    private let validationBehaviour: ValidationBehaviour
    
    public init(
        validate: ValidationBehaviour = .never,
        hideError: ErrorHideBehaviour = .onValueChanged,
        @ViewBuilder content: @escaping (FormValidator) -> Content
    ) {
        self.content = content
        self.validationBehaviour = validate
        self.errorHideBehaviour = hideError
    }
    
    public var body: some View {
        return content(formStateHandler.formValidator)
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
