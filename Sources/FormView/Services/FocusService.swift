//
//  FocusService.swift
//  
//
//  Created by Maxim Aliev on 19.02.2023.
//

import Foundation

struct FocusService {
    
    static func getNextFocusField(states: [FieldFocusState], currentFocusField: String) -> String {
        let nextIndex = (states.firstIndex { $0.isFocused } ?? -1) + 1
        let nextFocusField = nextIndex < states.count ? states[nextIndex].id : ""
        return nextFocusField == currentFocusField ? nextFocusField + " " : nextFocusField
    }
}
