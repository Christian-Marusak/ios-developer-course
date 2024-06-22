//
//  SwipingViewFactory.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import SwiftUI
import UIKit

protocol SwipingViewFactory {
    func makeSwipingView(hideBottomBar: Bool, joke: Joke?) -> UIViewController
    func handleSwipingViewEvent(_ event: SwipingViewEvent)
}

extension SwipingViewFactory where Self: ViewControllerCoordinator & CancellablesContaining {
    func makeSwipingView(hideBottomBar: Bool = false, joke: Joke? = nil) -> UIViewController {
        let store = container.resolve(type: SwipingViewStore.self)
        store.eventPublisher.sink { [weak self] event in
            self?.handleSwipingViewEvent(event)
        }
        .store(in: &cancellables)
        return HostingControllerHidesTabBar(
            rootView: SwipingView(store: store, joke: joke),
            hideBottomBar: hideBottomBar
        )
    }
}


