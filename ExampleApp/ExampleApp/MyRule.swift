//
//  MyRule.swift
//
//  Created by Maxim Aliev on 13.04.2023.
//

import FormView

extension TextValidationRule {
    static var myRule: Self {
        TextValidationRule(message: "Shold contain T") {
            $0.contains("T")
        }
    }
}
