//
//  FormViewModifier.swift
//  
//
//  Created by Maxim Aliev on 01.03.2023.
//

import SwiftUI

public struct FormViewModifier: ViewModifier {
    
    @State private var fieldFocusStates: [FieldFocusState] = []
    @State private var focusField: String = ""
    
    public func body(content: Content) -> some View {
        content
            .onPreferenceChange(FieldFocusStatesKey.self) { newValue in
                fieldFocusStates = newValue
            }
            .onSubmit(of: .text) {
                focusField = fieldFocusStates.focusNextField(currentFocusField: focusField)
            }
            .environment(\.focusField, focusField)
    }
}

extension View {
    
    public func formView() -> some View {
        modifier(FormViewModifier())
    }
}
