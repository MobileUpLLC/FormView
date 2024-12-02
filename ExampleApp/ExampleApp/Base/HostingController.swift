//
//  HostingController.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import SwiftUI
import UIKit

class HostingController<T: View>: UIHostingController<T> {
    override init(rootView: T) {
        super.init(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
