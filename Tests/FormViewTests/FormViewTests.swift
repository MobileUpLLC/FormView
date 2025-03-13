//
//  FormViewTests.swift
//  
//
//  Created by Maxim Aliev on 18.02.2023.
//

import SwiftUI
import XCTest
import ViewInspector
import Combine
@testable import FormView

final class FormViewTests: XCTestCase {
    @MainActor
    func testPreventInvalidInput() throws {
        var text1 = ""
        var text2 = ""
        let sut = InspectionWrapperView(
            wrapped: FormView { _ in
                ScrollView {
                    FormField(
                        value: Binding(get: { text1 }, set: { text1 = $0 }),
                        rules: [TextValidationRule.digitsOnly(message: "")],
                        content: { _ in
                            TextField(text1, text: Binding(get: { text1 }, set: { text1 = $0 }))
                       }
                    )
                    .id(1)
                    FormField(
                        value: Binding(get: { text2 }, set: { text2 = $0 }),
                        rules: [TextValidationRule.digitsOnly(message: "")],
                        content: { _ in
                            TextField(text2, text: Binding(get: { text2 }, set: { text2 = $0 }))
                       }
                    )
                    .id(2)
                }
            }
        )
        
        let exp = sut.inspection.inspect { view in
            let scrollView = try view.find(ViewType.ScrollView.self)
            let textField1 = try view.find(viewWithId: 1).find(ViewType.TextField.self)
            
            text1 = "123"
            
            try scrollView.callOnSubmit()
            try textField1.callOnChange(newValue: "New Focus Field", index: 1)
            try textField1.callOnChange(newValue: "123")
            XCTAssertEqual(try textField1.input(), "123")
            
            try textField1.callOnChange(newValue: "123_A")
            XCTAssertNotEqual(try textField1.input(), "123_A")
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 0.1)
    }
    
    @MainActor
    func testSubmitTextField() throws {
        var text1 = ""
        var text2 = ""
        let sut = InspectionWrapperView(
            wrapped: FormView { _ in
                ScrollView {
                    FormField(
                        value: Binding(get: { text1 }, set: { text1 = $0 }),
                        rules: [TextValidationRule.digitsOnly(message: "")],
                        content: { _ in
                            TextField(text1, text: Binding(get: { text1 }, set: { text1 = $0 }))
                       }
                    )
                    .id(1)
                    FormField(
                        value: Binding(get: { text2 }, set: { text2 = $0 }),
                        rules: [TextValidationRule.digitsOnly(message: "")],
                        content: { _ in
                            TextField(text2, text: Binding(get: { text2 }, set: { text2 = $0 }))
                       }
                    )
                    .id(2)
                }
            }
        )
        
        let exp = sut.inspection.inspect { view in
            let scrollView = try view.find(ViewType.ScrollView.self)
            let textField1 = try view.find(viewWithId: 1).find(ViewType.TextField.self)
            
            try scrollView.callOnSubmit()
            try textField1.callOnChange(newValue: "field2", index: 1)
            
            XCTAssertTrue(true)
        }
        
        ViewHosting.host(view: sut.environment(\.focusedFieldId, "1"))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testFocusNextField() throws {
        let fieldStates = [
            FieldState(id: "1", isFocused: true, onValidate: { true }),
            FieldState(id: "2", isFocused: false, onValidate: { false })
        ]
        
        var nextFocusField = FocusService.getNextFocusFieldId(states: fieldStates, currentFocusField: "1")
        nextFocusField = nextFocusField.trimmingCharacters(in: .whitespaces)
        XCTAssertEqual(nextFocusField, "2")
        
        nextFocusField = FocusService.getNextFocusFieldId(states: fieldStates, currentFocusField: "2")
        nextFocusField = nextFocusField.trimmingCharacters(in: .whitespaces)
        XCTAssertEqual(nextFocusField, "2")
    }
}
