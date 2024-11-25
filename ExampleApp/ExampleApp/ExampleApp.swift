//
//  ExampleApp.swift
//  Example
//
//  Created by Maxim Aliev on 28.01.2023.
//

import SwiftUI
import UIKit

class HostingController<T: View>: UIHostingController<T> {
    var isNavigationBarHidden: Bool { false }
    
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

enum StartFactory {
    static func createStartController() -> UINavigationController {
        let coordinator = StartCoordinator()
        let viewModel = StartVM(coordinator: coordinator)
        let controller = StartController(viewModel: viewModel)
        
        coordinator.router = controller
        
        return UINavigationController(rootViewController: controller)
    }
}

class StartCoordinator {
    weak var router: UIViewController?
    
    func push() {
        let controller = ContentFactory.createContentController()
        router?.navigationController?.pushViewController(controller, animated: true)
    }
}

class StartController: HostingController<StartScreen> {
    init(viewModel: StartVM) {
        super.init(rootView: StartScreen(viewModel: viewModel))
    }
}

class StartVM: ObservableObject {
    let coordinator: StartCoordinator
    
    init(coordinator: StartCoordinator) {
        self.coordinator = coordinator
    }
    
    func push() {
        coordinator.push()
    }
}

struct StartScreen: View {
    @ObservedObject var viewModel: StartVM
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Button {
                viewModel.push()
            } label: {
                Text("Open")
            }
        }
    }
}

enum ContentFactory {
    static func createContentController() -> UIViewController {
        let coordinator = ContentCoordinator()
        let viewModel = ContentViewModel(coordinator: coordinator)
        let controller = ContentController(viewModel: viewModel)
        
        coordinator.router = controller
        
        return controller
    }
}

class ContentCoordinator {
    weak var router: UIViewController?
    
    func pop() {
        router?.navigationController?.popViewController(animated: true)
    }
}

class ContentController: HostingController<ContentView> {
    init(viewModel: ContentViewModel) {
        super.init(rootView: ContentView(viewModel: viewModel))
        print("init ContentController")
    }
    
    deinit {
        print("deinit ContentController")
    }
}
