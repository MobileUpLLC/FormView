# FormView

<div align="leading">
    <a href="https://developer.apple.com/swift">
        <img src="https://img.shields.io/badge/language-Swift_5-green" alt="Swift5" />
    </a>
    <a href="https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview" >
        <img src="https://img.shields.io/badge/iOS-15.0+-orange?style=flat"/>
    </a>
    <a href="https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview" >
        <img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"/>
    </a>
    <a href="https://github.com/MobileUpLLC/Utils/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" />
    </a>
</div>
<br>

Lightweight library for grouping input fields.

Each field has a set of rules to be validated. On form validation all fields gets validated one-by-one. Failed rules for each field passed to field itself, to show error, for example.

## Features
* Input field fully customizable.
* Shift focus to next field on return.
* Shif focus to first failed field of form validation.
* Validate form with custom behaviour.
* Display/Hide error for every input field with custom behaviour.
* A banch of predefined text validation rules for most cases.
* Custom validation rules.

## Usage
1. Create input field and display error for failed validation rules, if needed.
```swift
struct MyField: View {
    let title: String
    let text: Binding<String>
    // Failed rules come from FormField during whole form validation.
    let failedRules: [TextValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            // Display error.
            if failedRules.isEmpty == false {
                // Show error for first failed rule.
                Text(failedRules[0].errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}
```

2. Group input fields into form.
```swift
struct ContentView: View {
    @State var name: String = ""
    
    @State private var isAllFieldValid = false
    
    var body: some View {
        FormView( First failed field 
            validate: .never, // Form will be validated on user action.
            hideError: .onValueChanged, // Error for field wil be hidden on field value change.
            isAllFieldValid: $isAllFieldValid // Property indicating the result of validation of all fields without focus
        ) { proxy in
            FormField(
                value: $name,
                rules: [TextValidationRule.notEmpty(message: "Name field should no be empty")],
                isRequired: true, // field parameter, necessary for correct determination of validity of all fields
            ) { failedRules in
                MyField(title: "Name", text: $name, failedRules: failedRules)
            }
            // Other input fields...
            Button("Validate") {
                // Validate form on user action.
                print("Form is valid: \(proxy.validate())")
            }
            .disabled(isAllFieldValid == false) // Use isAllFieldValid to automatically disable the action button
        }
    }
}
```

## Documentation
### Valildation Behaviour
Form validated at one of three specific times:
* `onFieldValueChanged` - each field validated on it's value changed.
* `onFieldFocusLost` - each field validated on focus lost.
* `never` - on call `proxy.validate()`. Default behaviour. First failed field is focused automatically.

### Error Hiding Behaviour
Error for each field gets hidden at one of three specific times:
* `onValueChanged` - value of field with error has changed. Defaule behaviour.
* `onFocus` - field with error is focused..
* `onFucusLost` - field with error lost focus.

### Is All Field Valid
Property indicating the result of validation of all fields without focus. Using this property you can additionally build ui update logic, for example block the next button.

### Custom Validation Rules
One of two ways:
1. Adopt protocol `ValidationRule`:
```swift
public protocol ValidationRule {
    associatedtype Value
    
    func check(value: Value) -> Bool
}
```

2. Extend `TextValidationRule`:
```swift
extension TextValidationRule {
    static var myRule: Self {
        TextValidationRule(message: "Text should not be empty") { value in
            value.isEmpty == false
        }
    }
}
```

A banch of predefind rules for text validation is available via `TextValidationRule`:
* notEmpty - value not empty.
* digitsOnly - value contains only digits.
* lettersOnly - value contains only letters.
* email - is valid email.
* minLenght/maxLenth - value length greate/less.
* regex - evaluate regular expresstion.
* equalTo - value equal to another value. Useful for password confirmation.
* etc...

### Outer Validation Rules
If you need to display validation errors from external services (e.g., a backend), follow these steps:
1. Create an `OuterValidationRule` enum:
```swift
enum OuterValidationRule {
    case duplicateName
    
    var message: String {
        switch self {
        case .duplicateName:
            return "This name already exists"
        }
    }
}
```

2. Update the text field component:
```swift
struct TextInputField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    let failedRules: [TextValidationRule]
    @Binding var outerRules: [OuterValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
                .background(Color.white)
            if let errorMessage = getErrorMessage() {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .frame(height: 50)
        .onChange(of: text) { _ in
            outerRules = []
        }
    }
    
    private func getErrorMessage() -> String? {
        if let message = failedRules.first?.message {
            return message
        } else if let message = outerRules.first?.message {
            return message
        } else {
            return nil
        }
    }
    
    init(
        title: LocalizedStringKey,
        text: Binding<String>,
        failedRules: [TextValidationRule],
        outerRules: Binding<[OuterValidationRule]> = .constant([])
    ) {
        self.title = title
        self._text = text
        self.failedRules = failedRules
        self._outerRules = outerRules
    }
}
```
3. Update the text field initialization in your view:
```swift
TextInputField(
    title: "Name",
    text: $viewModel.name,
    failedRules: failedRules,
    outerRules: $viewModel.nameOuterRules
)
```

4. In your ViewModel, declare a `@Published` property of type `OuterValidationRule` and update its rules as needed:
```swift
class ContentViewModel: ObservableObject {
    @Published var nameOuterRules: [OuterValidationRule] = []
    
    func applyNameOuterRules() {
        nameOuterRules = [.duplicateName]
    }
}
```


### Implementation Details
FormView doesn't use any external dependencies.

## Requirements
- Swift 5.0
- iOS 15.0

## Installation
### SPM

```swift
dependencies: [
    .package(
        url: "https://github.com/MobileUpLLC/FormView",
        .upToNextMajor(from: "1.3.0")
    )
]
```

## License
FormView is destributed under the [MIT license](https://github.com/MobileUpLLC/FormView/blob/main/LICENSE).
