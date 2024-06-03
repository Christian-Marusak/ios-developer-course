//
//  AppCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import Foundation
import UIKit
import Combine

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating, ObservableObject {
    @Published var isAuthorizedFlow: Bool = false
    
    init() {
        if isAuthorizedFlow {
            rootViewController = makeTabBarFlow()
        } else {
            rootViewController = makeLoginFlow()
        }
    }
    
    private(set) var rootViewController: UIViewController = UIViewController()
    private lazy var cancellables = Set<AnyCancellable>()
    
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
    func makeLoginFlow() -> UIViewController {
        let coordinator = LoginFlowCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return coordinator.rootViewController
    }
    
    func makeTabBarFlow() -> UIViewController {
        let coordinator = MainTabBarCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return coordinator.rootViewController
    }
    
}

private extension AppCoordinator {
    func handle(_ event: MainTabBarCoordinatorEvent) {
        switch event {
        case .logout(let coordinator):
            rootViewController = makeLoginFlow()
            release(coordinator: coordinator)
            isAuthorizedFlow = false
        }
    }
    
    func handle(_ event: SignInNavigationCoordinatorEvent) {
        switch event {
        case .login(let coordinator):
            rootViewController = makeTabBarFlow()
            release(coordinator: coordinator)
            isAuthorizedFlow = true
        }
    }
}
