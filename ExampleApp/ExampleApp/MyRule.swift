//
//  MyRule.swift
//
//  Created by Maxim Aliev on 13.04.2023.
//

import FormView

extension ValidationRule {
    static var myRule: Self {
        Self.custom(conditions: [.manual, .onFieldValueChanged, .onFieldFocus]) {
            return $0.contains("T") ? nil : "Should contain T"
        }
    }
}
