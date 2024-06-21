//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import DependencyInjection
import UIKit
import SwiftUI
import Combine

enum MainTabBarCoordinatorEvent {
    case logout(_ coordinator: MainTabBarCoordinator)
}

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    var childCoordinators = [Coordinator]()
    private(set) lazy var tabBarController = makeTabBarController()
    private var eventSubject = PassthroughSubject<MainTabBarCoordinatorEvent, Never>()
    private lazy var cancellables = Set<AnyCancellable>()
}

// MARK: -Start coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            setupCategoriesView(),
            setupSwipingCardView(),
            setupProfileView(),
        ]
    }
    func handleDeepling(deeplink: Deeplink) {
        switch deeplink {
            case let .onboarding(page):
             makeOnboardingFlow(page)
        default:
            break
        }
        
        childCoordinators.forEach{ $0.handleDeepling(deeplink: deeplink) }
    }
}

// MARK: Factory Method
private extension MainTabBarCoordinator {
    func makeOnboardingCoordinator(_ page: Int) -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator(container: container)
        
        coordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event: event)
        }
        .store(in: &cancellables)
        return coordinator
    }
    
    func makeOnboardingFlow(_ page: Int) {
        let coordinator = makeOnboardingCoordinator(page)
        startChildCoordinator(coordinator)
        tabBarController.present(coordinator.rootViewController, animated: true)
    }
    
    func handle(event: OnboardingNavigationEvent) {
        switch event {
        case let .dismiss(coordinator):
            release(coordinator: coordinator)
        }
    }

    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    func setupCategoriesView() -> UIViewController {
        let homeCoordinator = HomeNavigationCoordinator(container: container)
        startChildCoordinator(homeCoordinator)
        homeCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )
        return homeCoordinator.rootViewController
    }
    
    func setupSwipingCardView() -> UIViewController {
        
        let swipingCoordinator = SwipingViewNavigationCoordinator(container: container)
        startChildCoordinator(swipingCoordinator)
        swipingCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        swipingCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        return swipingCoordinator.rootViewController
    }
    
    func setupProfileView() -> UIViewController {
        let profileCoordinator = ProfileNavigationCoordinator(container: container)
        startChildCoordinator(profileCoordinator)
        
        let viewController = UIHostingController(rootView: ProfileView())
        viewController.title = "Profile View"
        profileCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        profileCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.blue], for: .normal)
        
        profileCoordinator.eventPublisher.sink { [weak self] event in
            guard let self else {
                return
            }
            switch event {
            case .logout:
                self.eventSubject.send(.logout(self))
            case .showOnboarding:
                self.makeOnboardingFlow(0)
            }
        }.store(in: &cancellables)
        return profileCoordinator.rootViewController
    }
    
}

extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController === tabBarController.viewControllers?.last {
//            rootViewController.showInfoAlert(title: "Up something is wrong...")
        }
    }
}

extension MainTabBarCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<MainTabBarCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
}

extension UIViewController {
    func showInfoAlert(title: String, message: String? = nil, handler: (() -> Void)? = nil) {
        guard presentedViewController == nil else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK?", style: .default) {_ in
         handler?()
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
}
