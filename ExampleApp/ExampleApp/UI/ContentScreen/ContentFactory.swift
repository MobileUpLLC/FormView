//
//  ContentFactory.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import UIKit

enum ContentFactory {
    static func createContentController() -> UIViewController {
        let coordinator = ContentCoordinator()
        let viewModel = ContentViewModel(coordinator: coordinator)
        let controller = ContentController(viewModel: viewModel)
        
        coordinator.router = controller
        
        return controller
    }
}
