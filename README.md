# FormView

<div align="leading">
  <a href="https://swiftpackageindex.com/maxial/FormView" >
    <img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"/>
  </a>
  <a href="https://swiftpackageindex.com/maxial/FormView" >
    <img src="https://img.shields.io/badge/iOS-15.0+-orange?style=flat"/>
  </a>
</div>
<br>

An easy-to-use SwiftUI library for working with a group of **TextFields**.

- [Features](#features)
- [Usage](#usage)
- [Example Project](#example-project)
- [Installation](#installation)
- [License](#license)

## Features

- Automatic transition between **TextFields** upon submission
- Validation of **TextFields** based on specified rules
- Prevention of incorrect input based on specified rules

## Usage

```swift
struct ContentView: View {
    
    @State var email: String = ""
    @State var phone: String = ""
    
    @State var emailFailedRules: [TextValidationRule] = []
    
    var body: some View {
        FormView {
            ScrollView(.vertical) {
                FormField(
                    "Email",
                    text: $email,
                    validationRules: [.email],
                    failedValidationRules: $emailFailedRules
                )
                if emailFailedRules.isEmpty == false {
                    Text("Email")
                        .foregroundColor(.red)
                }
                FormField(
                    "Phone",
                    text: $phone,
                    validationRules: [.digitsOnly],
                    inputRules: [.digitsOnly]
                )
            }
        }
    }
}
```

`ValidationRules` are used for automatic validation of text during input. All rules that have not passed the validation come with the `failedValidationRules`.

`InputRules` are used to prevent incorrect input.

You can also use a `.formView()` modifier instead of `FormView`:

```swift
ScrollView(.vertical) {
    ...
}
.formView()
```

## Example Project

[ExampleApp](https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview/-/tree/main/ExampleApp) provides several more interesting use cases of **FormView**.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code.

In Xcode 14 or later, select `File > Add Packages...` In the search bar, type

```
https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview
``` 

Then proceed with installation.

You can add **FormView** as a dependency to the `dependencies` value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview", from: "main"),
]
```

## License

FormView is released under the MIT license. [See LICENSE](https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview/-/blob/main/LICENSE) for details.
