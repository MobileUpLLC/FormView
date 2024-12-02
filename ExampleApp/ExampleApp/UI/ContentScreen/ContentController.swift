//
//  ContentController.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import SwiftUI

class ContentController: HostingController<ContentView> {
    init(viewModel: ContentViewModel) {
        super.init(rootView: ContentView(viewModel: viewModel))
        print("init ContentController")
    }
    
    deinit {
        print("deinit ContentController")
    }
}
