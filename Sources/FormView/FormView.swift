//
//  FormView.swift
//  
//
//  Created by Maxim Aliev on 27.01.2023.
//

import SwiftUI

public struct FormView<Content: View>: View {
    @State private var fieldFocusStates: [FieldFocusState] = []
    @State private var focusField: String = ""
    
    @ViewBuilder private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
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
