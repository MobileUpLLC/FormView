//
//  MyFormField.swift
//  Example
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI
import FormView

struct MyFormField: View {
    private let title: LocalizedStringKey
    private let text: Binding<String>
    private let failedValidationRules: [TextValidationRule]
    
    init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        failedValidationRules: [TextValidationRule] = []
    ) {
        self.title = title
        self.text = text
        self.failedValidationRules = failedValidationRules
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            if failedValidationRules.isEmpty == false {
                Text(failedValidationRules.first?.getErrorMessage() ?? "failed")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.red)
            }
        }
    }
}


