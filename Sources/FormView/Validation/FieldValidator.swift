//
//  FieldValidator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

final class FieldValidator<Value: Equatable, Rule: ValidationRule> where Value == Rule.Value {
    private let rules: [Rule]
    
    init(rules: [Rule]) {
        self.rules = rules
    }
   
    func validate(value: Value) -> [Rule] {
        return rules.filter {
            $0.check(value: value) == false
        }
    }
}
