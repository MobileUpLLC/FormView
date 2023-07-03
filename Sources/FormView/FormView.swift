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
    @State private var fieldStates: [FieldState] = .empty
    @State private var currentFocusedFieldId: String = .empty
    
    @ViewBuilder private let content: Content
    
    private let formValidator = FormValidator()
    private let errorHideBehaviour: ErrorHideBehaviour
    private let validationBehaviour: ValidationBehaviour
    
    public init(
        validate: ValidationBehaviour = .never,
        hideError: ErrorHideBehaviour = .onValueChanged,
        @ViewBuilder content: (FormValidator) -> Content
    ) {
        self.content = content(formValidator)
        self.validationBehaviour = validate
        self.errorHideBehaviour = hideError
    }
    
    public var body: some View {
        content
            .onPreferenceChange(FieldStatesKey.self) { newValue in
                fieldStates = newValue
                
                let focusedField = newValue.first { $0.isFocused }
                currentFocusedFieldId = focusedField?.id ?? .empty
               
                // Замыкание onValidateRun вызывается методом validate() FormValidator'a.
                formValidator.onValidateRun = { focusOnFirstFailedField in
                    let resutls = newValue.map { $0.akk() }
                   
                    // Фокус на первом зафейленом филде.
                    if let index = resutls.firstIndex(of: false), focusOnFirstFailedField {
                        currentFocusedFieldId = fieldStates[index].id
                    }
                        
                    return resutls.reduce(into: true) { $0 = $0 && $1 }
                }
            }
            .onSubmit(of: .text) {
                currentFocusedFieldId = FocusService.getNextFocusFieldId(
                    states: fieldStates,
                    currentFocusField: currentFocusedFieldId
                )
            }
            .environment(\.focusedFieldId, currentFocusedFieldId)
            .environment(\.errorHideBehaviour, errorHideBehaviour)
            .environment(\.validationBehaviour, validationBehaviour)
    }
}

extension String {
    static var empty: String { "" }
}
