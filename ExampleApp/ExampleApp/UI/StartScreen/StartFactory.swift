//
//  StartFactory.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import UIKit

enum StartFactory {
    static func createStartController() -> UINavigationController {
        let coordinator = StartCoordinator()
        let viewModel = StartViewModel(coordinator: coordinator)
        let controller = StartController(viewModel: viewModel)
        
        coordinator.router = controller
        
        return UINavigationController(rootViewController: controller)
    }
}
