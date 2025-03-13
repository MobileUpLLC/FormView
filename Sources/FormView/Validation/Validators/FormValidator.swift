//
//  FormValidator.swift
//  
//
//  Created by Nikolai Timonin on 03.07.2023.
//

import Foundation

public struct FormValidator {
    var onValidateRun: ((Bool) async -> Bool)?
    
    public init() {
        onValidateRun = nil
    }
    
    public func validate(focusOnFirstFailedField: Bool = true) async -> Bool {
        guard let onValidateRun else {
            assertionFailure("onValidateRun closure not found")
            return false
        }
        
        return await onValidateRun(focusOnFirstFailedField)
    }
}
