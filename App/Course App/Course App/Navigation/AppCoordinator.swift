//
//  AppCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import Foundation
import UIKit

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating {
    private(set) lazy var rootViewController = makeTabBarFlow()
    
    var childCoordinators = [Coordinator]()
}


// MARK: - Start coordinator

extension AppCoordinator {
    func start() {
        setupAppUI()
    }
    
    func setupAppUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28), .foregroundColor: UIColor.blue]
    }
    
    
    func handleDeepling(deeplink: Deeplink) {
        childCoordinators.forEach{ $0.handleDeepling(deeplink: deeplink )}
    }
}


// MARK: - Factory methods
private extension AppCoordinator {
    func makeTabBarFlow() -> UIViewController {
        let coordinator = MainTabBarCoordinator()
        childCoordinators.append(coordinator)
        coordinator.start()
        return coordinator.rootViewController
    }
}
