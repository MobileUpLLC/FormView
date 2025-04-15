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
    let failedRules: [ValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            // Display error.
            if let errorMessage = failedRules.first?.message, errorMessage.isEmpty == false {
                Text(errorMessage)
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
    
    var body: some View {
        FormView( First failed field 
            validate: [.manual], // Form will be validated on user action.
            hideError: .onValueChanged // Error for field wil be hidden on field value change.
        ) { proxy in
            FormField(
                value: $name,
                rules: [ValidationRule.notEmpty(conditions: [.manual], message: "Name field should no be empty")]
            ) { failedRules in
                MyField(title: "Name", text: $name, failedRules: failedRules)
            }
            // Other input fields...
            Button("Validate") {
                // Validate form on user action.
                print("Form is valid: \(proxy.validate())")
            }
        }
    }
}
```

## Documentation
### Valildation Behaviour
The form can be validated under one or multiple conditions simultaneously, such as:
* `onFieldValueChanged` - each field validated on it's value changed.
* `onFieldFocus` - each field validated on focus gain.
* `onFieldFocusLost` - each field validated on focus lost.
* `manual` - on call `proxy.validate()`. Default behaviour. First failed field is focused automatically.

### Error Hiding Behaviour
Error for each field gets hidden at one of three specific times:
* `onValueChanged` - value of field with error has changed. Defaule behaviour.
* `onFocus` - field with error is focused..
* `onFucusLost` - field with error lost focus.

### Custom Validation Rules

Extend `ValidationRule`:
```swift
extension ValidationRule {
    static var myRule: Self {
        Self.custom(conditions: [.manual, .onFieldValueChanged, .onFieldFocus]) {
            return ($0.isEmpty == false, "Text should not be empty")
        }
    }
}
```

A banch of predefind rules for text validation is available via `ValidationRule`:
* notEmpty - value not empty.
* digitsOnly - value contains only digits.
* lettersOnly - value contains only letters.
* email - is valid email.
* minLenght/maxLenth - value length greate/less.
* regex - evaluate regular expresstion.
* etc...

### External Validation Rules
If you need to display validation errors from external services (e.g., a backend) use `ValidationRule.external`:
```swift
ValidationRule.external { [weak self] in
    guard let self else {
        return (true, "")
    }

    return await self.availabilityCheckAsync($0)
}

private func availabilityCheckAsync(_ value: String) async -> (Bool, String) {
    let isAvailable = try await ...

    return (isAvailable, "Not available")
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
        .upToNextMajor(from: "1.1.2")
    )
]
```

## License
FormView is destributed under the [MIT license](https://github.com/MobileUpLLC/FormView/blob/main/LICENSE).
