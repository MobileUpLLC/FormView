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
    let text: Binding<String>
    let failedRules: [TextValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            if failedRules.isEmpty == false {
                Text(failedRules[0].getErrorMessage())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .frame(height: 50)
    }
}


