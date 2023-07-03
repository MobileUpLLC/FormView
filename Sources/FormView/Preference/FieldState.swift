//
//  FieldFocusStates.swift
//  
//
//  Created by Maxim Aliev on 15.02.2023.
//

import SwiftUI

struct FieldState {
    var id: String
    var isFocused: Bool
    var akk: () -> Bool
}

extension FieldState: Equatable {
    static func == (lhs: FieldState, rhs: FieldState) -> Bool {
        return lhs.id == rhs.id && lhs.isFocused == rhs.isFocused
    }
}

struct FieldStatesKey: PreferenceKey {
    static var defaultValue: [FieldState] = []
    
    static func reduce(value: inout [FieldState], nextValue: () -> [FieldState]) {
        value += nextValue()
    }
}
