//
//  JumpOnSubmitModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

struct JumpOnSubmitModifier: ViewModifier {
    @Environment(\.focusField) var focusField
    
    private let id: String
    @FocusState private var isFocused: Bool
    
    init() {
        self.id = UUID().uuidString
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: focusField) { newValue in
                isFocused = newValue.trimmingCharacters(in: .whitespaces) == id
            }
            .preference(
                key: FieldFocusStatesKey.self,
                value: [FieldFocusState(id: id, isFocused: isFocused)]
            )
            .focused($isFocused)
    }
}

extension View {
    func jumpOnSubmit() -> some View {
        modifier(JumpOnSubmitModifier())
    }
}
