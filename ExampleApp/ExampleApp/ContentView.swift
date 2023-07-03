//
//  ContentView.swift
//  Example
//
//  Created by Maxim Aliev on 28.01.2023.
//

import SwiftUI
import FormView

struct ContentView: View {
    @State var name: String = ""
    @State var age: String = ""
    @State var pass: String = ""
    @State var confirmPass: String = ""
    
    var body: some View {
        FormView(
            validate: .onFieldFocusLost,
            hideError: .onValueChanged
        ) { proxy in
            FormField(
                value: $name,
                rules: [TextValidationRule.noSpecialCharacters, .notEmpty, .newRule]
            ) { failedRules in
                TextInputField(title: "Name", text: $name, failedRules: failedRules)
            }
            FormField(
                value: $age,
                rules: [TextValidationRule.digitsOnly, .maxLength(2)]
            ) { failedRules in
                TextInputField(title: "Age", text: $age, failedRules: failedRules)
            }
            FormField(
                value: $pass,
                rules: [TextValidationRule.atLeastOneDigit, .atLeastOneLetter]
            ) { failedRules in
                SecureInputField(title: "Password", text: $pass, failedRules: failedRules)
            }
            FormField(
                value: $confirmPass,
                rules: [TextValidationRule.equalTo(pass), .notEmpty]
            ) { failedRules in
                SecureInputField(title: "Confirm Password", text: $confirmPass, failedRules: failedRules)
            }
            Button("Validate") {
                print("Form is valid: \(proxy.validate())")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            Color(red: 245 / 255.0, green: 246 / 255.0, blue: 250 / 255.0)
                .ignoresSafeArea()
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
