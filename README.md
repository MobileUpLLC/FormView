# FormView

<div align="leading">
  <a href="https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview" >
    <img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"/>
  </a>
  <a href="https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview" >
    <img src="https://img.shields.io/badge/iOS-15.0+-orange?style=flat"/>
  </a>
</div>
<br>

An easy-to-use SwiftUI library for working with a group of input fields.

- [Usage](#usage)
- [License](#license)


## Usage

Create project specific input field with display error suppourt via failed validation rules.
```swift
struct TextInputField: View {
    let title: LocalizedStringKey
    let text: Binding<String>
    // Failed rules come from FormField on validation fail.
    let failedRules: [TextValidationRule]
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: text)
                .background(Color.white)
            // Display error.
            if failedRules.isEmpty == false {
                Text(failedRules[0].errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}
```

Use project specific input field inside `FormField`.
```swift
struct ContentView: View {
    @State var name: String = ""
    
    var body: some View {
        FormView(
            validate: .never,
            hideError: .onValueChanged
        ) { proxy in
            FormField(
                value: $name,
                rules: [TextValidationRule.notEmpty]
            ) { failedRules in
                TextInputField(title: "Name", text: $name, failedRules: failedRules)
            }
            // Other input fields...
            Button("Validate") {
                // Validate form on action.
                print("Form is valid: \(proxy.validate())")
            }
        }
    }
}
```

## Installation

### SPM

```swift
dependencies: [
    .package(url: "https://gitlab.com/mobileup/mobileup/development-ios/libraries/formview", .upToNextMajor(from: "1.1.2"))
]
```

## License

FormView is released under the MIT license. [See LICENSE](https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview/-/blob/main/LICENSE) for details.
