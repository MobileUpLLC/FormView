//
//  FieldsValidationKey.swift
//  FormView
//
//  Created by Victor Kostin on 31.03.2025.
//

import SwiftUI

struct FieldsValidationKey: PreferenceKey {
    static var defaultValue: [Bool] = []
    
    static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
        value += nextValue()
    }
}
