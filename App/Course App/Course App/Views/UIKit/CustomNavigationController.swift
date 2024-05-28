//
//  CustomNavigationController.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import Foundation
import UIKit
import Combine

class CustomNavigationController: UINavigationController {
    
        enum CustomNavigationControllerEvent {
            case dismiss
            case swipeBack
        }
    
    private let eventSubject = PassthroughSubject<CustomNavigationControllerEvent, Never>()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            eventSubject.send(.dismiss)
        }
    }
}

// MARK:
extension CustomNavigationController: EventEmitting {
    var eventPublisher: AnyPublisher<CustomNavigationControllerEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}


extension CustomNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        return true
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated _: Bool
    ) {
        print(viewController)

    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated _: Bool
    ) {
        print(viewController)
    }
}
