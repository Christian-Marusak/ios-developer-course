//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import UIKit
import SwiftUI
import Combine

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator {
    var childCoordinators = [Coordinator]()
    private(set) lazy var tabBarController = makeTabBarController()
    private lazy var cancellables = Set<AnyCancellable>()
}

// MARK: -Start coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            setupCategoriesView(),
            setupSwipingCardView(),
            setupProfileView()
        ]
    }
    func handleDeepling(deeplink: Deeplink) {
        switch deeplink {
            case let .onboarding(page):
            let coordinator = makeOnboardingFlow()
            startChildCoordinator(coordinator)
            tabBarController.present(coordinator.rootViewController, animated: true)
        default:
            break
        }
        
        childCoordinators.forEach{ $0.handleDeepling(deeplink: deeplink) }
    }
}

// MARK: Factory Method
private extension MainTabBarCoordinator {
    func makeOnboardingFlow() -> ViewControllerCoordinator {
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


    
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    func setupCategoriesView() -> UIViewController {
        let categoriesNavigationController = UINavigationController(rootViewController: HomeViewController())
        categoriesNavigationController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.dash.header.rectangle"), tag: 0)
        
    return categoriesNavigationController
    }
    
    func setupSwipingCardView() -> UIViewController {
        
        let swipingCoordinator = SwipingNavigationCoordinator()
        startChildCoordinator(swipingCoordinator)
        
        let vcon = UIHostingController(rootView: SwipingView())
        vcon.title = "Scratch view"
        
        swipingCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        swipingCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        
    let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)]
        
        
        return swipingCoordinator.rootViewController
    }
    
    func setupProfileView() -> UIViewController {
        let profileView = ProfileNavigationCoordinator()
        startChildCoordinator(profileView)
        
        let vcon = UIHostingController(rootView: ProfileView())
        vcon.title = "Profile View"
        profileView.rootViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        profileView.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.blue], for: .normal)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futura(with: .size28)]
    
        return profileView.rootViewController
    }
    
}

extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController === tabBarController.viewControllers?.last {
//            rootViewController.showInfoAlert(title: "Up something is wrong...")
        }
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
