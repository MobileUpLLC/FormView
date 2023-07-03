//
//  FieldValidator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

struct FieldValidator<Rule: ValidationRule> {
    private let rules: [Rule]
    
    init(rules: [Rule]) {
        self.rules = rules
    }
   
    func validate(value: Rule.Value) -> [Rule] {
        return rules.filter {
            $0.check(value: value) == false
        }
    }
}
