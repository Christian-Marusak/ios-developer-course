//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//
import SwiftUI
import UIKit
import Combine

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    
    var childCoordinators = [Coordinator]()
//    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<OnboardingNavigationEvent, Never>()
    
    func handleDeepling(deeplink: Deeplink) {
        switch deeplink {
        case.onboarding(page: 0):
            pushNewPage(from: 0)
        default: break
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
    
    
}

// MARK: - Factories
private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView())
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
