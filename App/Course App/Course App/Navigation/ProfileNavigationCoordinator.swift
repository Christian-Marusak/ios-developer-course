//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//
import SwiftUI
import UIKit
import Foundation

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    func handleDeepling(deeplink: Deeplink) {
        
    }
    
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
    
    
}

// MARK: - Factories
private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView())
    }
}
