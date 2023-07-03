//
//  TextValidationRule+NewRule.swift
//  Example
//
//  Created by Maxim Aliev on 13.04.2023.
//

import FormView

extension TextValidationRule {
    static var newRule: Self {
        TextValidationRule { _ in return true }
    }
}
