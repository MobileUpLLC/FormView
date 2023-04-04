//
//  ValidationRule.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import Foundation

public protocol ValidationRule {
    associatedtype Value
    
    init(_ checkClosure: @escaping (Value) -> Bool)
    func check(value: Value) -> Bool
}
