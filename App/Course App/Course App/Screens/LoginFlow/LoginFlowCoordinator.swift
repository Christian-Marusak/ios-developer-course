//
//  LoginFlowCoordinator.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import DependencyInjection
import UIKit
import SwiftUI
import Combine

enum SignInNavigationCoordinatorEvent {
    case login(_ coordinator: LoginFlowCoordinator)
}

class LoginFlowCoordinator: NSObject, NavigationControllerCoordinator {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    
    private let eventSubject = PassthroughSubject<SignInNavigationCoordinatorEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        navigationController.setViewControllers([makeLoginView()], animated: false)
    }
    
    func handleDeepling(deeplink: Deeplink) {}
    
    
}

// MARK: - Factories
private extension LoginFlowCoordinator {
    func makeLoginView() -> UIViewController {
        let store = container.resolve(type: LoginViewStore.self)
        store.eventPublisher.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .login:
                eventSubject.send(.login(self))
            }
        }.store(in: &cancellables)
        return UIHostingController(rootView: LoginView(store: store))
    }
}

extension LoginFlowCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<SignInNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
