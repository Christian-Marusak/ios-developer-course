//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import UIKit
import SwiftUI

protocol OnboardingCoordinating: NavigationControllerCoordinator {}

final class OnboardingNavigationCoordinator: OnboardingCoordinating {
    func handleDeepling(deeplink: Deeplink) {
        
    }
    
    
    deinit {
        print("Deinit OnboardingNavigationCoordinator")
    }
    
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
//    private var cancellables = Set<AnyCancellable>()
//    private let eventSubject = PassthroughSubject<OnboardingNavigationEvent, Never>()
    var childCoordinators: [any Coordinator] = []
    
}

extension OnboardingNavigationCoordinator {
    
    func makeNavigationController() -> UINavigationController {
        let navigationController = CustomNavigationController()
//        navigationController.eventPublisher.sink { [weak self] value in
//            guard let seld else {
//                return
//            }
//            self.eventSubject.send(.dismiss(self))
//        }
//        .store(in: &cancellables)
        
        return navigationController
    }
    
    func start() {
        navigationController.setViewControllers(
            [makeOnboardingView(), makeOnboardingView(), makeOnboardingView()], animated: false)
    }
    
}

extension OnboardingCoordinating {
    func makeOnboardingView() -> UIViewController {
        let controller = UIHostingController(rootView: OnboardingView())
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        
        return controller
    }
}
