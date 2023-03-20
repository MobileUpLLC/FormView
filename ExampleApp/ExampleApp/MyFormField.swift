//
//  MyFormField.swift
//  Example
//
//  Created by Maxim Aliev on 12.02.2023.
//

import SwiftUI
import FormView

struct MyFormField: View {
    
    private let title: LocalizedStringKey
    private let text: Binding<String>
    private let validationRules: [TextValidationRule]
    private let inputRules: [TextValidationRule]
    
    @State private var failedValidationRules: [TextValidationRule] = []
    
    init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        validationRules: [TextValidationRule] = [],
        inputRules: [TextValidationRule] = []
    ) {
        self.title = title
        self.text = text
        self.validationRules = validationRules
        self.inputRules = inputRules
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Color.white
                    .cornerRadius(12)
                    .shadow(
                        color: Color(red: 216/255.0, green: 220/255.0, blue: 232/255.0),
                        radius: 3,
                        x: .zero,
                        y: 3
                    )
                ZStack {
                    FormField(
                        title,
                        text: text,
                        validationRules: validationRules,
                        inputRules: inputRules,
                        failedValidationRules: $failedValidationRules
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .tint(Color.black)
                    .frame(height: 40)
                    .padding(.horizontal, 12)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(failedValidationRules.isEmpty ? Color.clear : .red, lineWidth: 1)
                }
            }
            .frame(height: 40)
            
            if failedValidationRules.isEmpty == false {
                Text(String.concat(strings: failedValidationRules.map { $0.message }))
                    .lineLimit(2)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
        .frame(height: 72)
    }
}

struct MySecondFormField: View {
    private let title: LocalizedStringKey
    private let validationRules: [TextValidationRule]
    private let inputRules: [TextValidationRule]
    private let addClearButton: Bool
    private let supportsSecure: Bool
    
    @Binding private var text: String
    @State private var failedValidationRules: [TextValidationRule] = []
    @State private var isSecure = true
    
    @FocusState private var isFocused: Bool
    
    init(
        _ title: LocalizedStringKey = "",
        text: Binding<String>,
        validationRules: [TextValidationRule] = [],
        inputRules: [TextValidationRule] = [],
        addClearButton: Bool = false,
        supportsSecure: Bool = true
    ) {
        self.title = title
        self._text = text
        self.validationRules = validationRules
        self.inputRules = inputRules
        self.addClearButton = addClearButton
        self.supportsSecure = supportsSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                if text.isEmpty == false {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(title)
                                .font(Font(UIFont.systemFont(ofSize: 13, weight: .regular) as CTFont))
                                .foregroundColor(getTopPlaceholderColor())
                                .padding(.top, 4)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
                
                VStack(spacing: 0) {
                    if text.isEmpty == false {
                        Spacer()
                    }
                    
                    Group {
                        if supportsSecure {
                            FormField(
                                title,
                                text: $text,
                                validationRules: validationRules,
                                inputRules: inputRules,
                                failedValidationRules: $failedValidationRules,
                                isSecure: $isSecure
                            )
                            .focused($isFocused)
                        } else {
                            FormField(
                                title,
                                text: $text,
                                validationRules: validationRules,
                                inputRules: inputRules,
                                failedValidationRules: $failedValidationRules
                            )
                            .focused($isFocused)
                        }
                    }
                    .font(Font(UIFont.systemFont(ofSize: 15, weight: .regular) as CTFont))
                    .foregroundColor(Color.black)
                    .tint(Color.gray)
                    .frame(height: 20)
                    .padding(.bottom, text.isEmpty ? 0 : 7)
                }
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    if addClearButton && text.isEmpty == false {
                        Image(systemName: "xmark.circle.fill")
                            .renderingMode(.template)
                            .foregroundColor(
                                failedValidationRules.isEmpty
                                    ? Color.purple
                                    : Color.red
                            )
                            .onTapGesture {
                                text = .empty
                            }
                    }
                    
                    if supportsSecure {
                        getEyeButtonImage()
                            .renderingMode(.template)
                            .foregroundColor(
                                failedValidationRules.isEmpty
                                    ? Color.purple
                                    : Color.red
                            )
                            .onTapGesture {
                                isSecure.toggle()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isFocused = true
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .cornerRadius(24)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(getBorderColor(), lineWidth: 1)
            }
            
            Spacer(minLength: 8)
            
            if failedValidationRules.isEmpty == false {
                Text(failedValidationRules.first?.message ?? .empty)
                    .lineLimit(1)
                    .font(Font(UIFont.systemFont(ofSize: 13, weight: .regular) as CTFont))
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 16)
            }
        }
        .frame(height: 77)
        .animation(.easeIn, value: failedValidationRules.isEmpty)
        .animation(.easeIn, value: isFocused)
        .animation(.easeIn, value: isSecure)
        .animation(.easeIn, value: text.isEmpty)
    }
    
    private func getBorderColor() -> Color {
        if failedValidationRules.isEmpty == false {
            return .red
        }
        
        if isFocused || text.isEmpty == false {
            return .purple
        }
        
        return .gray
    }
    
    private func getTopPlaceholderColor() -> Color {
        return failedValidationRules.isEmpty
            ? .purple
            : .red
    }
    
    private func getEyeButtonImage() -> Image {
        if isSecure {
            return Image(systemName: "eye")
        } else {
            return Image(systemName: "eye.slash")
        }
    }
}
