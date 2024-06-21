//
//  LoginFlowCoordinator.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import UIKit
import SwiftUI
import Combine
import DependencyInjection

enum SignInNavigationCoordinatorEvent {
    case login(_ coordinator: LoginFlowCoordinator)
}

class LoginFlowCoordinator: NSObject, NavigationControllerCoordinator {
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    
    var container: Container
    private let eventSubject = PassthroughSubject<SignInNavigationCoordinatorEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var childCoordinators = [Coordinator]()
    
    init(container: Container) {
        self.container = container
    }
    
    func start() {
        navigationController.setViewControllers([makeLoginView()], animated: false)
    }
    
    func handleDeepling(deeplink: Deeplink) {}
    
    
}

// MARK: - Factories
private extension LoginFlowCoordinator {
    func makeLoginView() -> UIViewController {
        let loginView = LoginView()
        loginView.eventPublisher.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .login:
                eventSubject.send(.login(self))
            }
        }.store(in: &cancellables)
        return UIHostingController(rootView: loginView)
    }
}

extension LoginFlowCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<SignInNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
