//
//  FormView.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import SwiftUI

enum ValidationBehaviour {
    case onFieldValueChanged
    case onFieldFocusLost
    case never
}

public class FormValidator {
    var onValidateRun: (() -> Bool)?
    
    public init() {
        onValidateRun = nil
    }
    
    public func validate() -> Bool {
        guard let onValidateRun else {
            assertionFailure("onValidateRun closure not found")
            return false
        }
        
        return onValidateRun()
    }
}

public struct FormView<Content: View>: View {
    @State private var fieldFocusStates: [FieldFocusState] = []
    @State private var currentFocusedFieldId: String = ""
    
    @ViewBuilder private let content: Content
    
    private let formValidator: FormValidator
    
    public init(
        validator: FormValidator,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.formValidator = validator
    }
    
    public var body: some View {
        content
            .onPreferenceChange(FieldFocusStatesKey.self) { newValue in
               fieldFocusStates = newValue
                
                formValidator.onValidateRun = {
                    let resutls = newValue.map { $0.akk() }
                        
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
    }
}
