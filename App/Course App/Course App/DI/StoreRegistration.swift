//
//  StoreRegistration.swift
//  Course App
//
//  Created by Christián on 17.06.2024.
//

import DependencyInjection

enum StoreRegistration {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: SwipingViewStore.self,
            in: .new,
            initializer: SwipingViewStore.init
        )
        
        container.autoregister(
            type: HomeViewStore.self,
            in: .new,
            initializer: HomeViewStore.init
        )
        
        container.autoregister(
            type: LoginViewStore.self,
            in: .new,
            initializer: LoginViewStore.init
        )
    }
}
