//
//  ContentView.swift
//  Example
//
//  Created by Maxim Aliev on 28.01.2023.
//

import SwiftUI
import FormView

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @State private var isAllFieldValid = false
    
    var body: some View {
        FormView(
            validate: [.manual, .onFieldValueChanged, .onFieldFocus],
            hideError: .onValueChanged,
            isAllFieldValid: $isAllFieldValid
        ) { proxy in
            FormField(
                value: $viewModel.name,
                rules: viewModel.nameValidationRules,
                isRequired: true
            ) { failedRules in
                TextInputField(title: "Name", text: $viewModel.name, failedRules: failedRules)
            }
            .disabled(viewModel.isLoading)
            FormField(
                value: $viewModel.age,
                rules: viewModel.ageValidationRules,
                isRequired: false
            ) { failedRules in
                TextInputField(title: "Age", text: $viewModel.age, failedRules: failedRules)
            }
            .disabled(viewModel.isLoading)
            FormField(
                value: $viewModel.pass,
                rules: viewModel.passValidationRules,
                isRequired: true
            ) { failedRules in
                SecureInputField(title: "Password", text: $viewModel.pass, failedRules: failedRules)
            }
            .disabled(viewModel.isLoading)
            FormField(
                value: $viewModel.confirmPass,
                rules: viewModel.confirmPassValidationRules,
                isRequired: true
            ) { failedRules in
                SecureInputField(title: "Confirm Password", text: $viewModel.confirmPass, failedRules: failedRules)
            }
            .disabled(viewModel.isLoading)
            if viewModel.isLoading {
                ProgressView()
            }
            Button("Validate") {
                Task {
                    print("Form is valid: \(await proxy.validate())")
                }
            }
            .disabled(isAllFieldValid == false || viewModel.isLoading)
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
        ContentView(viewModel: ContentViewModel(coordinator: ContentCoordinator()))
    }
}
