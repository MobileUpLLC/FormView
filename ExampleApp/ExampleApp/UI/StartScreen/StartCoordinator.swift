//
//  StartCoordinator.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import UIKit

class StartCoordinator {
    weak var router: UIViewController?
    
    func push() {
        let controller = ContentFactory.createContentController()
        router?.navigationController?.pushViewController(controller, animated: true)
    }
}
