//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import DependencyInjection
import SwiftUI
import UIKit
import Combine


final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    deinit {
        print("Deinit ProfileNavigationCoordinator")
    }
        
    var childCoordinators = [Coordinator]()
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    
    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }

}



// MARK: - Factories
private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        let profileView = ProfileView()
        profileView.eventPublisher.sink { [weak self] event in
            self?.eventSubject.send(event)
        }.store(in: &cancellables)
        return UIHostingController(rootView: profileView)
    }
    
}

extension ProfileNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
