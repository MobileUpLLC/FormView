//
//  FieldValidator.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import SwiftUI

struct FieldValidator {
    private let rules: [ValidationRule]
    
    init(rules: [ValidationRule]) {
        self.rules = rules
    }
   
    func validate(
        value: String,
        condition: ValidationBehaviour,
        isNeedToCheckExternal: Bool
    ) async -> [ValidationRule] {
        var failedRules: [ValidationRule] = []
        
        for rule in rules where (rule.isExternal == false || isNeedToCheckExternal)
        && rule.conditions.contains(condition) {
            if await rule.check(value: value) == false {
                failedRules.append(rule)
            }
        }
        
        return failedRules
    }
}
