//
//  FocusField.swift
//  
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI

private struct FocusedFieldIdKey: EnvironmentKey {
    static var defaultValue: String = .empty
}

extension EnvironmentValues {
    var focusedFieldId: String {
        get { self[FocusedFieldIdKey.self] }
        set { self[FocusedFieldIdKey.self] = newValue }
    }
}

private struct ValidationBehaviourKey: EnvironmentKey {
    static var defaultValue: ValidationBehaviour = .never
}

extension EnvironmentValues {
    var validationBehaviour: ValidationBehaviour {
        get { self[ValidationBehaviourKey.self] }
        set { self[ValidationBehaviourKey.self] = newValue }
    }
}

private struct ErrorHideBehaviourKey: EnvironmentKey {
    static var defaultValue: ErrorHideBehaviour = .onValueChanged
}

extension EnvironmentValues {
    var errorHideBehaviour: ErrorHideBehaviour {
        get { self[ErrorHideBehaviourKey.self] }
        set { self[ErrorHideBehaviourKey.self] = newValue }
    }
}
