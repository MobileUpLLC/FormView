//
//  FormValidator.swift
//  
//
//  Created by Nikolai Timonin on 03.07.2023.
//

import Foundation

public class FormValidator: ObservableObject {
    var onValidateRun: ((Bool) -> Bool)?
    
    public init() {
        onValidateRun = nil
    }
    
    public func validate(focusOnFirstFailedField: Bool = true) -> Bool {
        guard let onValidateRun else {
            assertionFailure("onValidateRun closure not found")
            return false
        }
        
        return onValidateRun(focusOnFirstFailedField)
    }
}
