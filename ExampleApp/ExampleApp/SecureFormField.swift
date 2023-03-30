//
//  SecureFormField.swift
//  Example
//
//  Created by Maxim Aliev on 29.03.2023.
//

import SwiftUI
import FormView

struct SecureFormField: View {
    
    private let title: LocalizedStringKey
    private let text: Binding<String>
    private let failedValidationRules: [TextValidationRule]
    
    @FocusState private var isFocused: Bool
    @State private var isSecure = true
    
    init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        failedValidationRules: [TextValidationRule] = []
    ) {
        self.title = title
        self.text = text
        self.failedValidationRules = failedValidationRules
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Group {
                    if isSecure {
                        SecureField(title, text: text)
                            .textContentType(.newPassword)
                    } else {
                        TextField(title, text: text)
                    }
                }
                .focused($isFocused)
                .background(Color.white)
                
                HStack {
                    Spacer()
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .onTapGesture {
                            isSecure.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isFocused = true
                            }
                        }
                }
            }
            
            if failedValidationRules.isEmpty == false {
                Text(failedValidationRules.first?.message ?? .empty)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.red)
            }
        }
    }
}
