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

public class FormValidator {
    var onValidateRun: ((Bool) -> Bool)?
    
    public init() {
        onValidateRun = nil
    }
    
    public func validate(focusOnFirstFailedField: Bool = true) -> Bool {
        guard let onValidateRun else {
            assertionFailure("onValidateRun closure not found")
            return false
        }
        
        return onValidateRun(focusOnFirstFailedField)
    }
}

public struct FormView<Content: View>: View {
    @State private var fieldFocusStates: [FieldFocusState] = []
    @State private var currentFocusedFieldId: String = ""
    
    @ViewBuilder private let content: Content
    
    private let formValidator = FormValidator()
    private let errorHideBehaviour: ErrorHideBehaviour
    private let validationBehaviour: ValidationBehaviour
    
    public init(
        validationBehaviour: ValidationBehaviour = .never,
        errorHideBehaviour: ErrorHideBehaviour = .onValueChanged,
        @ViewBuilder content: (FormValidator) -> Content
    ) {
        self.content = content(formValidator)
        self.errorHideBehaviour = errorHideBehaviour
        self.validationBehaviour = validationBehaviour
    }
    
    public var body: some View {
        content
            .onPreferenceChange(FieldFocusStatesKey.self) { newValue in
                fieldFocusStates = newValue
                
                let focusedField = newValue.first { $0.isFocused }
                currentFocusedFieldId = focusedField?.id ?? ""
               
                // Замыкание вызывается методом validate() FormValidator'a.
                formValidator.onValidateRun = { focusOnFirstFailedField in
                    let resutls = newValue.map { $0.akk() }
                   
                    // Фокус на первом зафейленом филде.
                    if let index = resutls.firstIndex(of: false), focusOnFirstFailedField {
                        currentFocusedFieldId = fieldFocusStates[index].id
                    }
                        
                    let isValid = resutls.reduce(into: true) { $0 = $0 && $1 }
                   
                    return isValid
                }
            }
            .onSubmit(of: .text) {
                currentFocusedFieldId = FocusService.getNextFocusFieldId(
                    states: fieldFocusStates,
                    currentFocusField: currentFocusedFieldId
                )
            }
            .environment(\.focusedFieldId, currentFocusedFieldId)
            .environment(\.errorHideBehaviour, errorHideBehaviour)
            .environment(\.validationBehaviour, validationBehaviour)
    }
}
