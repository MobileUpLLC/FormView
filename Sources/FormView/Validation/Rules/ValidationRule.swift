//
//  ValidationRule.swift
//  
//
//  Created by Maxim Aliev on 29.01.2023.
//

import Foundation

public protocol ValidationRule: Equatable {
    associatedtype Value
    
    var id: UUID { get }
    
    func check(value: Value) -> Bool
}

extension ValidationRule {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
