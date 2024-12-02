//
//  ContentCoordinator.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import UIKit

class ContentCoordinator {
    weak var router: UIViewController?
    
    func pop() {
        router?.navigationController?.popViewController(animated: true)
    }
}
