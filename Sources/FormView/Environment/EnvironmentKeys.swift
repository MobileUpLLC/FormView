//
//  FocusField.swift
//  
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI

// MARK: - FocusedFieldIdKey

private struct FocusedFieldIdKey: EnvironmentKey {
    static var defaultValue: String = .empty
}

extension EnvironmentValues {
    var focusedFieldId: String {
        get { self[FocusedFieldIdKey.self] }
        set { self[FocusedFieldIdKey.self] = newValue }
    }
}

// MARK: - ValidationBehaviourKey

private struct ValidationBehaviourKey: EnvironmentKey {
    static var defaultValue: [ValidationBehaviour] = [.manual]
}

extension EnvironmentValues {
    var validationBehaviour: [ValidationBehaviour] {
        get { self[ValidationBehaviourKey.self] }
        set { self[ValidationBehaviourKey.self] = newValue }
    }
}

// MARK: - ErrorHideBahaviourKey

private struct ErrorHideBehaviourKey: EnvironmentKey {
    static var defaultValue: ErrorHideBehaviour = .onValueChanged
}

extension EnvironmentValues {
    var errorHideBehaviour: ErrorHideBehaviour {
        get { self[ErrorHideBehaviourKey.self] }
        set { self[ErrorHideBehaviourKey.self] = newValue }
    }
}
