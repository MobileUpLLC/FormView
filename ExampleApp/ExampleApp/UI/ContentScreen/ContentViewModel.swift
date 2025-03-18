//
//  ContentViewModel.swift
//  Example
//
//  Created by Nikolai Timonin on 28.07.2023.
//

import SwiftUI
import FormView

class ContentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var pass: String = ""
    @Published var confirmPass: String = ""
    @Published var isLoading = false
    
    var nameValidationRules: [ValidationRule] = []
    var ageValidationRules: [ValidationRule] = []
    var passValidationRules: [ValidationRule] = []
    var confirmPassValidationRules: [ValidationRule] = []
    
    private let coordinator: ContentCoordinator
    
    init(coordinator: ContentCoordinator) {
        self.coordinator = coordinator
        print("init ContentViewModel")
        
        setupValidationRules()
    }
    
    private func setupValidationRules() {
        nameValidationRules = [
            ValidationRule.notEmpty(conditions: [.manual, .onFieldValueChanged, .onFieldFocus], message: "Name empty"),
            ValidationRule.noSpecialCharacters(
                conditions: [.manual, .onFieldValueChanged, .onFieldFocus],
                message: "No spec chars"
            ),
            ValidationRule.myRule,
            ValidationRule.external { [weak self] in
                await self?.availabilityCheckAsync($0)
            }
        ]
        
        ageValidationRules = [
            ValidationRule.digitsOnly(
                conditions: [.manual, .onFieldValueChanged],
                message: "Digits only"
            ),
            ValidationRule.maxLength(
                conditions: [.manual, .onFieldValueChanged],
                count: 2,
                message: "Max length 2"
            )
        ]
        
        passValidationRules = [
            ValidationRule.atLeastOneDigit(conditions: [.manual, .onFieldValueChanged], message: "One digit"),
            ValidationRule.atLeastOneLetter(conditions: [.manual, .onFieldValueChanged], message: "One letter"),
            ValidationRule.notEmpty(conditions: [.manual, .onFieldValueChanged], message: "Pass not empty")
        ]
        
        confirmPassValidationRules = [
            ValidationRule.notEmpty(conditions: [.manual, .onFieldValueChanged], message: "Confirm pass not empty"),
            ValidationRule.custom(conditions: [.manual, .onFieldValueChanged]) { [weak self] in
                return $0 == self?.pass ? nil : "Not equal to pass"
            }
        ]
    }
    
    @MainActor
    private func availabilityCheckAsync(_ value: String) async -> String? {
        print(#function)
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let isAvailable = Bool.random()
        
        isLoading = false
        
        return isAvailable ? nil : "Not available"
    }
    
    deinit {
        print("deinit ContentViewModel")
    }
}
