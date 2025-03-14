//
//  MyFormField.swift
//  Example
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI
import FormView

struct TextInputField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    let failedRules: [ValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
                .background(Color.white)
            if let errorMessage = failedRules.first?.message {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .frame(height: 50)
    }
    
    init(
        title: LocalizedStringKey,
        text: Binding<String>,
        failedRules: [ValidationRule]
    ) {
        self.title = title
        self._text = text
        self.failedRules = failedRules
    }
}
