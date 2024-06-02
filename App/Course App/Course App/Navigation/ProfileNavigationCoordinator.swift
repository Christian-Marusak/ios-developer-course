//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//
import SwiftUI
import UIKit
import Combine

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator, UITabBarControllerDelegate {
    
    private(set) lazy var tabBarController = makeTabBarController()
    var childCoordinators = [Coordinator]()
//    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<OnboardingNavigationEvent, Never>()
    
    func handleDeepling(deeplink: Deeplink) {
        switch deeplink {
        case .onboarding(_):
            let coordinator = makeProfileFlow()
            startChildCoordinator(coordinator)
            tabBarController.present(coordinator.rootViewController, animated: true)
        default:
            break
        }
    }
    
    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
    
    
}

extension ProfileNavigationCoordinator: OnboardingCoordinating {
    
    func makeOnboardingView(page: Int) -> UIViewController {
        UIHostingController(rootView: OnboardingView(coordinator: OnboardingNavigationCoordinator(), page: page))
    }
    
    func pushNewPage(from page: Int) {
        navigationController.pushViewController(makeOnboardingView(page: 0), animated: true)
    }
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    
}

// MARK: - Factories
private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView())
    }
    func makeProfileFlow() -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator()
        
        coordinator.eventPublisher.sink { [weak self] myEvent in
            self?.handle(event: myEvent)
        }
        .store(in: &cancellables)
        return coordinator
    }
    
    func handle(event: OnboardingNavigationEvent) {
        switch event {
        case let .dismiss(coordinator):
            release(coordinator: coordinator)
        }
    }
}



private extension ProfileNavigationCoordinator {
    
    func makeNavigationController() -> UINavigationController {
        let navigationController = CustomNavigationController()
//        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.eventPublisher.sink { [weak self] event in
            guard let self else {
                return
            }
            self.eventSubject.send(.dismiss(self))
        }
        .store(in: &cancellables)
        
        return navigationController
    }

}
