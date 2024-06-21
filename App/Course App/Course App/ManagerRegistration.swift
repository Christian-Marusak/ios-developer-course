//
//  ManagerRegistration.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import DependencyInjection

enum ManagerRegistration {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: StoreManaging.self,
            in: .shared,
            initializer: FirebaseStoreManager.init
        )
        
        container.autoregister(
            type: KeychainManaging.self,
            in: .shared,
            initializer: KeychainManager.init
        )
        
        container.autoregister(
            type: KeychainServicing.self,
            in: .shared,
            initializer: KeychainService.init
        )
        
        container.autoregister(
            type: SwipingViewStore.self,
            in: .new,
            initializer: SwipingViewStore.init
        )
    }
}
