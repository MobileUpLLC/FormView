//
//  FieldFocusStates.swift
//  
//
//  Created by Maxim Aliev on 15.02.2023.
//

import SwiftUI

struct FieldFocusState: Equatable {
    var id: String
    var isFocused: Bool
}

struct FieldFocusStatesKey: PreferenceKey {
    static var defaultValue: [FieldFocusState] = []
    
    static func reduce(value: inout [FieldFocusState], nextValue: () -> [FieldFocusState]) {
        value += nextValue()
    }
}
