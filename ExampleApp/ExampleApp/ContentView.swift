//
//  ContentView.swift
//  Example
//
//  Created by Maxim Aliev on 28.01.2023.
//

import SwiftUI
import FormView

struct ContentView: View {
    
    @State var companyName: String = ""
    
    @State var fstEmployeeName: String = ""
    @State var fstEmployeeAge: String = ""
    @State var fstEmployeeEmail: String = ""
    @State var sndEmployeeName: String = ""
    @State var sndEmployeeAge: String = ""
    @State var sndEmployeeEmail: String = ""
    
    @State var companyPhone: String = ""
    @State var pass: String = ""
    @State var confirmPass: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 245/255.0, green: 246/255.0, blue: 250/255.0)
                .ignoresSafeArea()
            FormView {
                ScrollView(.vertical) {
                    FormField(
                        value: $companyName,
                        validationRules: [
                            TextValidationRule.noSpecialCharacters
                        ]
                    ) { failedValidationRules in
                        MyFormField(
                            "Company",
                            text: $companyName,
                            failedValidationRules: failedValidationRules
                        )
                    }
                    
                    HStack {
                        FormField(
                            value: $fstEmployeeName,
                            validationRules: [
                                TextValidationRule.noSpecialCharacters
                            ]
                        ) { failedValidationRules in
                            MyFormField(
                                "Name",
                                text: $fstEmployeeName,
                                failedValidationRules: failedValidationRules
                            )
                            .frame(width: 100)
                        }
                        FormField(
                            value: $fstEmployeeAge,
                            validationRules: [
                                TextValidationRule.digitsOnly,
                                .maxLength(2)
                            ]
                        ) { failedValidationRules in
                            MyFormField(
                                "Age",
                                text: $fstEmployeeAge,
                                failedValidationRules: failedValidationRules
                            )
                            .frame(width: 60)
                        }
                        FormField(
                            value: $fstEmployeeEmail,
                            validationRules: [TextValidationRule.email]
                        ) { failedValidationRules in
                            MyFormField(
                                "Email",
                                text: $fstEmployeeEmail,
                                failedValidationRules: failedValidationRules
                            )
                        }
                    }
                    
                    HStack {
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                            .font(.system(size: 12))
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                    
                    VStack(spacing: 8) {
                        FormField(
                            value: $companyPhone,
                            validationRules: [
                                TextValidationRule.minLength(11),
                                .maxLength(11),
                                .digitsOnly
                            ]
                        ) { failedValidationRules in
                            MyFormField(
                                "Company phone",
                                text: $companyPhone,
                                failedValidationRules: failedValidationRules
                            )
                        }
                        
                        FormField(
                            value: $pass,
                            validationRules: [
                                TextValidationRule.atLeastOneDigit,
                                .atLeastOneLetter
                            ]
                        ) { failedValidationRules in
                            SecureFormField(
                                "Pass",
                                text: $pass,
                                failedValidationRules: failedValidationRules
                            )
                        }
                        FormField(
                            value: $confirmPass,
                            validationRules: [
                                TextValidationRule.atLeastOneDigit,
                                .atLeastOneLetter,
                                .equalTo(pass)
                            ]
                        ) { failedValidationRules in
                            SecureFormField(
                                "Confirm pass",
                                text: $confirmPass,
                                failedValidationRules: failedValidationRules
                            )
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
