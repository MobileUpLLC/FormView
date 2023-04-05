//
//  ContentView.swift
//  Example
//
//  Created by Maxim Aliev on 28.01.2023.
//

import SwiftUI
import FormView

extension TextValidationRule {
    static var newRule: Self {
        TextValidationRule { _ in return false }
    }
}

struct ContentView: View {
    @State var companyName: String = ""
    @State var employeeName: String = ""
    @State var employeeAge: String = ""
    @State var employeeEmail: String = ""
    @State var companyPhone: String = ""
    @State var pass: String = ""
    @State var confirmPass: String = ""
    
    private let nameRules: [TextValidationRule] = [.noSpecialCharacters, .newRule]
    private let ageRules: [TextValidationRule] = [.digitsOnly, .maxLength(2)]
    private let emailRules: [TextValidationRule] = [.email]
    private let phoneRules: [TextValidationRule] = [
        .minLength(11),
        .maxLength(11),
        .digitsOnly
    ]
    private let passRules: [TextValidationRule] = [
        .atLeastOneDigit,
        .atLeastOneLetter
    ]
    
    var body: some View {
        FormView {
            ScrollView(.vertical) {
                formField("Company", value: $companyName, rules: nameRules)
                formField("Name", value: $employeeName, rules: nameRules)
                formField("Age", value: $employeeAge, rules: ageRules)
                formField("Email", value: $employeeEmail, rules: emailRules)
                formField("Company phone", value: $companyPhone, rules: phoneRules)
                formField("Pass", value: $pass, rules: passRules, isSecure: true)
                formField("Confirm pass", value: $confirmPass, rules: passRules + [.equalTo(pass)], isSecure: true)
            }
            .padding(.horizontal, 16)
        }
        .background(
            Color(red: 245 / 255.0, green: 246 / 255.0, blue: 250 / 255.0)
                .ignoresSafeArea()
        )
    }
    
    private func formField(
        _ title: LocalizedStringKey,
        value: Binding<String>,
        rules: [TextValidationRule],
        isSecure: Bool = false
    ) -> some View {
        FormField(
            value: value,
            validationRules: rules
        ) { failedValidationRules in
            fieldView(
                title,
                value: value,
                rules: rules,
                failedRules: failedValidationRules,
                isSecure: isSecure
            )
        }
    }
    
    @ViewBuilder
    private func fieldView(
        _ title: LocalizedStringKey,
        value: Binding<String>,
        rules: [TextValidationRule],
        failedRules: [TextValidationRule],
        isSecure: Bool
    ) -> some View {
        if isSecure {
            SecureFormField(
                title,
                text: value,
                failedValidationRules: failedRules
            )
        } else {
            MyFormField(
                title,
                text: value,
                failedValidationRules: failedRules
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
