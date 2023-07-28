//
//  ContentViewModel.swift
//  Example
//
//  Created by Nikolai Timonin on 28.07.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var pass: String = ""
    @Published var confirmPass: String = ""
}
