//
//  FieldFocusStates.swift
//  
//
//  Created by Maxim Aliev on 15.02.2023.
//

import SwiftUI

struct FieldFocusState {
    var id: String
    var isFocused: Bool
    var akk: () -> Bool
}

extension FieldFocusState: Equatable {
    static func == (lhs: FieldFocusState, rhs: FieldFocusState) -> Bool {
        return lhs.id == rhs.id && lhs.isFocused == rhs.isFocused
    }
}

struct FieldFocusStatesKey: PreferenceKey {
    static var defaultValue: [FieldFocusState] = []
    
    static func reduce(value: inout [FieldFocusState], nextValue: () -> [FieldFocusState]) {
        value += nextValue()
    }
}
