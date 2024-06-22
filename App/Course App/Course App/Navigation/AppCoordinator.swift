//
//  AppCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//


import FirebaseAuth
import UIKit
import Combine
import DependencyInjection
import TestModule

protocol AppCoordinating: ViewControllerCoordinator {}

enum Constants {
    static let showOnboardingKey = "showOnboardingPage"
}

final class AppCoordinator: AppCoordinating, ObservableObject {
    @Published var isAuthorizedFlow: Bool = Auth.auth().currentUser != nil
    var container = Container()
    var childCoordinators = [Coordinator]()
    private lazy var cancellables = Set<AnyCancellable>()
    private(set) lazy var rootViewController: UIViewController = {
        if isAuthorizedFlow {
            makeTabBarFlow()
        } else {
            makeLoginFlow()
        }
    }()
    
}


// MARK: - Start coordinator

extension AppCoordinator {
    
    func start() {
        assembleDependencyInjectionContainer()
        setupAppUI()
    }

    func assembleDependencyInjectionContainer() {
        ManagerRegistration.registerDependencies(to: container)
        ServiceRegistration.registerDependencies(to: container)
        StoreRegistration.registerDependencies(to: container)
    }
    
    func setupAppUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28), .foregroundColor: UIColor.blue]
    }
    
    
    func handleDeepling(deeplink: Deeplink) {
        if case .onboarding(let page) = deeplink, !isAuthorizedFlow{
            UserDefaults.standard.set(page, forKey: Constants.showOnboardingKey)
            debugPrint(UserDefaults.standard.integer(forKey: Constants.showOnboardingKey))
        } else {
            childCoordinators.forEach{ $0.handleDeepling(deeplink: deeplink )}
        }
    }
}


// MARK: - Factory methods
private extension AppCoordinator {
    func makeLoginFlow() -> UIViewController {
        let coordinator = LoginFlowCoordinator(container: container)
        startChildCoordinator(coordinator)
        coordinator.eventPublisher.sink { [weak self] event in
             self?.handle(event)
        }
        .store(in: &cancellables)
        return coordinator.rootViewController
    }
    
    func makeTabBarFlow() -> UIViewController {
        let coordinator = MainTabBarCoordinator(container: container)
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
            DispatchQueue.main.async {
                self.isAuthorizedFlow = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let page = UserDefaults.standard.value(forKey: Constants.showOnboardingKey) as? Int {
                        self.handleDeepling(deeplink: .onboarding(page: page))
                        UserDefaults.standard.removeObject(forKey: Constants.showOnboardingKey)
                    }
                }
            }
        }
    }
}
