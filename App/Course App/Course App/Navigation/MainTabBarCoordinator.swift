//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import UIKit
import SwiftUI

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator {
    var childCoordinators = [Coordinator]()
    private(set) lazy var tabBarController = makeTabBarController()
}

// MARK: -Start coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            setupCategoriesView(),
            setupSwipingCardView()
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
    }
}

// MARK: Factory Method
private extension MainTabBarCoordinator {
    
    

    
    func makeOnboardingFlow() -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator()
        return coordinator
    }


    
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    func setupCategoriesView() -> UIViewController {
        let categoriesNavigationController = UINavigationController(rootViewController: HomeViewController())
        categoriesNavigationController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.dash.header.rectangle"), tag: 0)
        
        
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .brown
//        appearance.shadowImage = UIImage()
//        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28)]
//
//        categoriesNavigationController.navigationBar.standardAppearance = appearance
//        categoriesNavigationController.navigationBar.compactAppearance = appearance
//        categoriesNavigationController.navigationBar.scrollEdgeAppearance = appearance
//        categoriesNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28)]
        
    return categoriesNavigationController
    }
    
    func setupSwipingCardView() -> UIViewController {
        
        let swipingCoordinator = SwipingNavigationCoordinator()
        startChildCoordinator(swipingCoordinator)
        
        let vcon = UIHostingController(rootView: SwipingView())
        vcon.title = "Scratch view"
        
        swipingCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        swipingCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.blue], for: .normal)
//        swipingNavigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.red], for: .selected)
        
    let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futura(with: .size28)]
        
//        swipingNavigationController.navigationBar.standardAppearance = appearance
//        swipingNavigationController.navigationBar.compactAppearance = appearance
//        swipingNavigationController.navigationBar.scrollEdgeAppearance = appearance
        
        
        return swipingCoordinator.rootViewController
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
        guard present == nil else {
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
