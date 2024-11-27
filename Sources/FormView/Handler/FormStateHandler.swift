//
//  FormStateHandler.swift
//
//
//  Created by Victor Kostin on 27.11.2024.
//

import SwiftUI

class FormStateHandler: ObservableObject {
    @Published var fieldStates: [FieldState] = .empty
    @Published var currentFocusedFieldId: String = .empty
    @Published var formValidator = FormValidator()
    
    func updateFieldStates(newStates: [FieldState]) {
        fieldStates = newStates
        
        let focusedField = newStates.first { $0.isFocused }
        currentFocusedFieldId = focusedField?.id ?? .empty
       
        // Замыкание onValidateRun вызывается методом validate() FormValidator'a.
        formValidator.onValidateRun = { [weak self] focusOnFirstFailedField in
            guard let self else {
                return false
            }
            
            let resutls = newStates.map { $0.onValidate() }
           
            // Фокус на первом зафейленом филде.
            if let index = resutls.firstIndex(of: false), focusOnFirstFailedField {
                currentFocusedFieldId = fieldStates[index].id
            }
               
            return resutls.allSatisfy { $0 }
        }
    }
    
    func submit() {
        currentFocusedFieldId = FocusService.getNextFocusFieldId(
            states: fieldStates,
            currentFocusField: currentFocusedFieldId
        )
    }
}
