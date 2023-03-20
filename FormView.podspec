Pod::Spec.new do |spec|

  spec.name         = "FormView"
  spec.version      = "0.0.1"
  spec.summary      = "An easy-to-use SwiftUI library for working with a group of TextFields."
  spec.description  = "Automatic transition between TextFields upon submission, validation of TextFields based on specified rules and prevention of incorrect input based on specified rules"
  spec.homepage     = "https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview"

  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "MobileUp iOS Team" => "hello@mobileup.ru" }

  spec.platform     = :ios, "15.0"
  spec.ios.frameworks = 'SwiftUI'
  spec.swift_version = ['5']
  
  spec.source = { :git => 'https://gitlab.com/mobileup/mobileup/development-ios/test-projects/formview', :tag => spec.version.to_s }
  spec.source_files  = "Sources/", "Sources/**/*.{swift}"
end
