//
//  FocusField.swift
//  
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI

private struct FocusedFieldIdKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var focusedFieldId: String {
        get { self[FocusedFieldIdKey.self] }
        set { self[FocusedFieldIdKey.self] = newValue }
    }
}
