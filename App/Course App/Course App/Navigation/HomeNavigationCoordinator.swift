//
//  HomeNavigationCoordinator.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import Combine
import DependencyInjection
import os
import SwiftUI
import UIKit

enum HomeNavigationCoordinatorEvent {}

protocol HomeNavigationCoordinating: NavigationControllerCoordinator {}

final class HomeNavigationCoordinator: HomeNavigationCoordinating, SwipingViewFactory, CancellablesContaining {
    // MARK: Properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()

    private let eventSubject = PassthroughSubject<HomeNavigationCoordinatorEvent, Never>()
    private let logger = Logger()
    var childCoordinators: [any Coordinator] = []
    var container: Container
    var cancellables = Set<AnyCancellable>()

    deinit {
        logger.info("Deinit HomeNavigationCoordinator")
    }

    init(container: Container) {
        self.container = container
    }
}

// MARK: - EventEmitting
extension HomeNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<HomeNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Start coordinator
extension HomeNavigationCoordinator {
    func start() {
        navigationController.setViewControllers(
            [makeHomeView()],
            animated: false
        )
    }
}

// MARK: - Factory methods
private extension HomeNavigationCoordinator {
    func makeHomeView() -> UIViewController {
        let store = container.resolve(type: HomeViewStore.self)
        store.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }.store(in: &cancellables)
        return  HomeViewController(store: store)
    }
}

// MARK: - Handling events
private extension HomeNavigationCoordinator {
    func handle(_ event: HomeViewEvent) {
        switch event {
        case let .itemTapped(joke):
            logger.info("Joke on home screen was tapped \(joke.text)")
            navigationController.pushViewController(
                makeSwipingView(
                    hideBottomBar: true,
                    joke: joke
                ),
                animated: true
            )
        }
    }
}

// MARK: - Handling SwipingView events
extension HomeNavigationCoordinator {
    func handleSwipingViewEvent(_ event: SwipingViewEvent) {
        switch event {
        case .dismiss:
            navigationController.popViewController(animated: true)
        }
    }
}

