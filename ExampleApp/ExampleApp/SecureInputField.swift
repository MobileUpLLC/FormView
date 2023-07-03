//
//  SecureInputField.swift
//  Example
//
//  Created by Maxim Aliev on 29.03.2023.
//

import SwiftUI
import FormView

struct SecureInputField: View {
    let title: LocalizedStringKey
    let text: Binding<String>
    let failedRules: [TextValidationRule]
    
    @FocusState private var isFocused: Bool
    @State private var isSecure = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                fieldView
                Spacer()
                eyeImage
            }
            .background(Color.white)
            messageView
            Spacer()
        }
        .frame(height: 40)
    }
    
    private var fieldView: some View {
        Group {
            if isSecure {
                SecureField(title, text: text)
                    .textContentType(.newPassword)
            } else {
                TextField(title, text: text)
            }
        }
        .focused($isFocused)
    }
    
    private var eyeImage: some View {
        Image(systemName: isSecure ? "eye" : "eye.slash")
            .onTapGesture {
                isSecure.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
    }
    
    @ViewBuilder
    private var messageView: some View {
        if failedRules.isEmpty == false {
            Text(failedRules.first?.getErrorMessage() ?? "failed")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.red)
        }
    }
}
