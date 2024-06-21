//
//  Coordinator.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import DependencyInjection
import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var container: Container { get }
    func start()
    func handleDeepling(deeplink: Deeplink)
}

extension Coordinator {
    func release(coordinator: Coordinator){
        childCoordinators.removeAll { $0 === coordinator }
        
    }
    
    func startChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func handleDeepling(deeplink: Deeplink) {}
}
