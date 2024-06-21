//
//  SwipingNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//
import Combine
import UIKit
import SwiftUI
import DependencyInjection

final class SwipingNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    func handleDeepling(deeplink: Deeplink) {
        
    }
    
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var container: Container
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        navigationController.setViewControllers([makeSwipingCard()], animated: false)
    }
    init(container: Container) {
        self.container = container
    }
    
    
}

// MARK: - Factories
private extension SwipingNavigationCoordinator {
    func makeSwipingCard() -> UIViewController {
        
        let store = container.resolve(type: SwipingViewStore.self)
        store.eventPublisher.sink { [weak self] event in
            self?.navigationController.popToRootViewController(animated: true)
        }.store(in: &cancellables)
       return UIHostingController(rootView: SwipingView(store: store))
    }
}
