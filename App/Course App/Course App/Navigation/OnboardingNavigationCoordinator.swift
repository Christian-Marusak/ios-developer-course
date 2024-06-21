//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import DependencyInjection
import UIKit
import SwiftUI
import Combine

protocol OnboardingCoordinating: NavigationControllerCoordinator {
    func pushNewPage(from page: Int)
}

enum OnboardingNavigationEvent {
    case dismiss(Coordinator)
}

final class OnboardingNavigationCoordinator: OnboardingCoordinating {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
   
    static private(set) var numberOfPages: Int = 3
    
    func pushNewPage(from page: Int) {
        if page < Self.numberOfPages - 1 {
            navigationController.pushViewController(makeOnboardingView(page: page + 1), animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
        
    }
    
    func handleDeepling(deeplink: Deeplink) {
        switch deeplink {
        case.closeOnboarding:
            rootViewController.dismiss(animated: true)
        default: break
        }
    }
    
    deinit {
        print("Deinit OnboardingNavigationCoordinator")
    }
    
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<OnboardingNavigationEvent, Never>()
    var childCoordinators: [any Coordinator] = []
    
}

private extension OnboardingNavigationCoordinator {
    
    func makeNavigationController() -> UINavigationController {
        let navigationController = CustomNavigationController()
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

extension OnboardingNavigationCoordinator {
    func start() {
        navigationController.setViewControllers(
            [makeOnboardingView(page: 0)], animated: false)
    }
    
    func makeOnboardingView(page: Int) -> UIViewController {
        UIHostingController(rootView: OnboardingView(coordinator: self, page: page))
    }
}

extension OnboardingNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<OnboardingNavigationEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
