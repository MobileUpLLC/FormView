//
//  TextValidationRule+Error.swift
//  Example
//
//  Created by Maxim Aliev on 05.04.2023.
//

import FormView

extension TextValidationRule {
    var errorMessage: String {
        if self == .notEmpty {
            return "Not empty"
        } else {
            return "Failed"
        }
    }
}
