//
//  StartViewModel.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import Foundation

class StartViewModel: ObservableObject {
    let coordinator: StartCoordinator
    
    init(coordinator: StartCoordinator) {
        self.coordinator = coordinator
    }
    
    func push() {
        coordinator.push()
    }
}
