//
//  SwipingNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import UIKit
import SwiftUI

final class SwipingNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    func handleDeepling(deeplink: Deeplink) {
        
    }
    
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        navigationController.setViewControllers([makeSwipingCard(), makeSwipingCard(), makeSwipingCard()], animated: false)
    }
    
    
}

// MARK: - Factories
private extension SwipingNavigationCoordinator {
    func makeSwipingCard() -> UIViewController {
        UIHostingController(rootView: SwipingView())
    }
}
