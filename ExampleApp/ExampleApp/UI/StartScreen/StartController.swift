//
//  StartController.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import UIKit

class StartController: HostingController<StartView> {
    init(viewModel: StartViewModel) {
        super.init(rootView: StartView(viewModel: viewModel))
    }
}
