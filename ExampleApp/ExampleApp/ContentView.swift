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
            validate: .never,
            hideError: .onValueChanged
        ) { proxy in
            FormField(
                value: $name,
                rules: [
                    TextValidationRule.noSpecialCharacters(message: "No spec chars"),
                    .notEmpty(message: "Name empty"),
                    .myRule
                ]
            ) { failedRules in
                TextInputField(title: "Name", text: $name, failedRules: failedRules)
            }
            FormField(
                value: $age,
                rules: [
                    TextValidationRule.digitsOnly(message: "Digits only"),
                    .maxLength(count: 2, message: "Max length 2")
                ]
            ) { failedRules in
                TextInputField(title: "Age", text: $age, failedRules: failedRules)
            }
            FormField(
                value: $pass,
                rules: [
                    TextValidationRule.atLeastOneDigit(message: "One digit"),
                    .atLeastOneLetter(message: "One letter"),
                    .notEmpty(message: "Pass not empty")
                ]
            ) { failedRules in
                SecureInputField(title: "Password", text: $pass, failedRules: failedRules)
            }
            FormField(
                value: $confirmPass,
                rules: [
                    TextValidationRule.equalTo(value: pass,message: "Not equal to pass"),
                    .notEmpty(message: "Confirm pass not empty")
                ]
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
