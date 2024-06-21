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

protocol AppCoordinating: ViewControllerCoordinator {}

enum Constants {
    static let showOnboardingKey = "showOnboardingPage"
}

final class AppCoordinator: AppCoordinating, ObservableObject {
    var container = Container()
    
    @Published var isAuthorizedFlow: Bool = Auth.auth().currentUser != nil
    
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
        assembleDependencyInjectionContainer()
    }
    
    func assembleDependencyInjectionContainer() {
        ManagerRegistration.registerDependencies(to: container)
//        ServiceManager.registerDependencies(to: container)
//        StoreRegistration.registerDependencies(to: container)
    }
    
    func setupAppUI() {
        UITabBar.appearance().backgroundColor = .brown
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
            isAuthorizedFlow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let page = UserDefaults.standard.value(forKey: Constants.showOnboardingKey) as? Int {
                    self.handleDeepling(deeplink: .onboarding(page: page))
                    UserDefaults.standard.removeObject(forKey: Constants.showOnboardingKey)
                }
            }
        }
    }
}
