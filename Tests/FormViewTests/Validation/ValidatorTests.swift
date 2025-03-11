//
//  ValidatorTests.swift
//  
//
//  Created by Maxim Aliev on 19.02.2023.
//

import SwiftUI
import XCTest
@testable import FormView

final class ValidatorTests: XCTestCase {
    func testValidator() throws {
        var failedValidationRules: [TextValidationRule] = []
        
        let validator = FieldValidator<TextValidationRule>(
            rules: [.digitsOnly(message: ""), .maxLength(count: 4, message: "")]
        )
        
        failedValidationRules = validator.validate(value: "1")
        XCTAssertTrue(failedValidationRules.isEmpty)
        
        failedValidationRules = validator.validate(value: "12_A")
        XCTAssertTrue(failedValidationRules.isEmpty == false)
        failedValidationRules.removeAll()
        
        failedValidationRules = validator.validate(value: "12345")
        XCTAssertTrue(failedValidationRules.isEmpty == false)
        failedValidationRules.removeAll()
    }
}
