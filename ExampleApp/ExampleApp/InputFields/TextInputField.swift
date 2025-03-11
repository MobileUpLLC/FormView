//
//  MyFormField.swift
//  Example
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI
import FormView

enum OuterValidationRule {
    case duplicateName
    
    var message: String {
        switch self {
        case .duplicateName:
            return "This name already exists"
        }
    }
}

struct TextInputField: View {
    let title: LocalizedStringKey
    let text: Binding<String>
    let failedRules: [TextValidationRule]
    @Binding var outerRules: [OuterValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            if let errorMessage = getErrorMessage() {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .frame(height: 50)
    }
    
    private func getErrorMessage() -> String? {
        if let message = failedRules.first?.message {
            return message
        } else if let message = outerRules.first?.message {
            return message
        } else {
            return nil
        }
    }
    
    init(
        title: LocalizedStringKey,
        text: Binding<String>,
        failedRules: [TextValidationRule],
        outerRules: Binding<[OuterValidationRule]> = .constant([])
    ) {
        self.title = title
        self.text = text
        self.failedRules = failedRules
        self._outerRules = outerRules
    }
}
