//
//  JumpOnSubmitModifier.swift
//  
//
//  Created by Maxim Aliev on 23.03.2023.
//

import SwiftUI

public struct JumpOnSubmitModifier: ViewModifier {
    
    @Environment(\.focusField) var focusField
    
    private let id: String
    @FocusState private var isFocused: Bool
    
    public init() {
        self.id = UUID().uuidString
    }
    
    public func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: focusField) { newValue in
                isFocused = newValue.trimmingCharacters(in: .whitespaces) == id
            }
            .preference(
                key: FieldStatesKey.self,
                value: [
                    FieldState(id: id, isFocused: isFocused)
                ]
            )
    }
}

extension View {
    
    public func jumpOnSubmit() -> some View {
        modifier(JumpOnSubmitModifier())
    }
}
