//
//  FormViewModifier.swift
//  
//
//  Created by Maxim Aliev on 01.03.2023.
//

import SwiftUI

struct FormViewModifier: ViewModifier {
    
    @State private var fieldFocusStates: [FieldFocusState] = []
    @State private var focusField: String = ""
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(FieldFocusStatesKey.self) { newValue in
                fieldFocusStates = newValue
            }
            .onSubmit(of: .text) {
                focusField = FocusService.getNextFocusField(
                    states: fieldFocusStates,
                    currentFocusField: focusField
                )
            }
            .environment(\.focusField, focusField)
    }
}

extension View {
    
    func formView() -> some View {
        modifier(FormViewModifier())
    }
}
