//
//  TextValidationRuleTests.swift
//
//
//  Created by Maxim Aliev on 07.02.2023.
//

import XCTest
@testable import FormView

final class TextValidationRuleTests: XCTestCase {
    func testIgnoreEmpty() throws {
        try test(textRule: .digitsOnly(message: ""), trueString: "", falseString: "1234 A")
    }
    
    func testNotEmpty() throws {
        try test(textRule: .notEmpty(message: ""), trueString: "Not empty", falseString: "")
    }
    
    func testMinLength() throws {
        try test(textRule: .minLength(count: 4, message: ""), trueString: "1234", falseString: "123")
    }
    
    func testMaxLength() throws {
        try test(textRule: .maxLength(count: 4, message: ""), trueString: "1234", falseString: "123456")
    }
    
    func testAtLeastOneDigit() throws {
        try test(textRule: .atLeastOneDigit(message: ""), trueString: "Digit 5", falseString: "No Digits")
    }
    
    func testAtLeastOneLetter() throws {
        try test(textRule: .atLeastOneLetter(message: ""), trueString: "1234 A", falseString: "1234")
    }
    
    func testDigitsOnly() throws {
        try test(textRule: .digitsOnly(message: ""), trueString: "1234", falseString: "1234 A")
    }
    
    func testLettersOnly() throws {
        try test(textRule: .lettersOnly(message: ""), trueString: "Letters", falseString: "Digit 5")
    }
    
    func testAtLeastOneLowercaseLetter() throws {
        try test(textRule: .atLeastOneLowercaseLetter(message: ""), trueString: "LOWEr", falseString: "UPPER")
    }
    
    func testAtLeastOneUppercaseLetter() throws {
        try test(textRule: .atLeastOneUppercaseLetter(message: ""), trueString: "Upper", falseString: "lower")
    }
    
    func testAtLeastOneSpecialCharacter() throws {
        try test(textRule: .atLeastOneSpecialCharacter(message: ""), trueString: "Special %", falseString: "No special")
    }
    
    func testNoSpecialCharacters() throws {
        try test(textRule: .noSpecialCharacters(message: ""), trueString: "No special", falseString: "Special %")
    }
    
    func testEmail() throws {
        try test(textRule: .email(message: ""), trueString: "alievmaxx@gmail.com", falseString: "alievmaxx@.com")
    }
    
    func testNotRecurringPincode() throws {
        try test(textRule: .notRecurringPincode(message: ""), trueString: "1234", falseString: "5555")
    }
    
    func testRegex() throws {
        let dateRegex = "(\\d{2}).(\\d{2}).(\\d{4})"
        try test(textRule: .regex(value: dateRegex, message: ""), trueString: "21.12.2000", falseString: "21..2000")
    }
    
    private func test(textRule: TextValidationRule, trueString: String, falseString: String) throws {
        let isPassed = textRule.check(value: trueString)
        let isFailed = textRule.check(value: falseString) == false
        
        XCTAssertTrue(isPassed && isFailed)
    }
}
