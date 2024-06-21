//
//  SwipingViewStore.swift
//  Course App
//
//  Created by Christián on 19/06/2024.
//

import Foundation
import SwiftUI
import Combine

final class SwipingViewStore: ObservableObject, EventEmitting {
    
    private let jokesService = JokeServicing = JokeService(apiManager: APIManager())
    private let store: StoreManaging
    private let category: String? = nil
    private let keychainService: KeychainServicing
    private let eventSubject = PassthroughSubject<SwipingViewEvent, Never>()
    
    @Published var viewState: SwipingViewState = .initial
    
    init(store: StoreManaging, keychainService: KeychainServicing) {
        self.keychainService = keychainService
        self.store = store
//            self.category = joke?.categories.first
//            if let joke {
//                viewState.jokes.append(joke)
//            }
        }
    var eventPublisher: AnyPublisher<SwipingViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

extension SwipingViewStore {
    @MainActor
    func send(_ action: SwipingViewAction) {
        switch action {
        case let .dataFetched(jokes):
            viewState.jokes.append(contentsOf: jokes)
            viewState.status = .ready
            logger.info("thread: \(Thread.current.description)")
            break
        case .viewDidLoad:
            logger.info("thread: \(Thread.current.description)")
            viewState.status = .loading
            fetchRandomJokes()
        case let .didLike(jokeId, liked):
            break
        case .noMoreJokes:
            eventSubject.send(.dismiss)
        }
    }
}

private extension SwipingViewStore {
    
    func fetchRandomJokes() {
        logger.info("thread: \(Thread.current.description)")
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) {[weak self] group in guard let self else {
                return
            }
                for _ in 1...5 {
                    group.addTask {
                        if let category = self.category {
                            try await self.jokesService.fetchJokeForCategory(category)
                        } else {
                            try await self.jokesService.fetchRandomJoke()
                        }
                    }
                }

                var jokes: [Joke] = []
                for try await jokeResponse in group {
                    jokes.append(Joke(jokeResponse: jokeResponse, liked: false))
                }
                await send(.dataFetched(jokes))
            }
        }
    }
    
    func storeJokeLike(jokeId: String, liked: Bool) {
        Task {
            try await self.store.storeLike(jokeId: jokeId, liked: liked)
        }
    }
}
