//
//  SwipingNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import Combine
import DependencyInjection
import os
import SwiftUI
import UIKit

final class SwipingViewNavigationCoordinator: NSObject, NavigationControllerCoordinator, CancellablesContaining, SwipingViewFactory {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let logger = Logger()
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()
    var container: Container
    // MARK: Lifecycle
    deinit {
        logger.info("Deinit SwipingViewNavigationCoordinator")
    }

    init(container: Container) {
        self.container = container
    }
}
// MARK: - Start
extension SwipingViewNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeSwipingView()], animated: false)
    }
}

// MARK: - SwipingViewEvent handling
extension SwipingViewNavigationCoordinator {
    func handleSwipingViewEvent(_ event: SwipingViewEvent) {
        switch event {
        case .dismiss:
            navigationController.popToRootViewController(animated: true)
        }
    }
}
