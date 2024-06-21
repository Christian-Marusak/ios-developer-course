//  SwipingViewStore.swift
//  Course App
//
//  Created by Christián on 19/06/2024.
//

import Combine
import Foundation
import os

final class SwipingViewStore: ObservableObject, EventEmitting, Store {
    private let store: StoreManaging
    private let jokesService: JokeServicing
    private var category: String?
    private let logger = Logger()
    private var counter: Int = 0
    private let eventSubject = PassthroughSubject<SwipingViewEvent, Never>()
    private var initialJoke: Joke?
    @Published var state: SwipingViewState = .initial

    init(store: StoreManaging, jokeService: JokeServicing) {
        self.store = store
        self.jokesService = jokeService
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
            let jokes = initialJoke == nil ? jokes : [initialJoke!] + jokes
            state.jokes.append(contentsOf: jokes)
            state.status = .ready
            logger.info("thread: \(Thread.current.description)")
            break
        case let .viewDidLoad(joke):
            logger.info("thread: \(Thread.current.description)")
            initialJoke = joke
            category = joke?.categories.first
            state.status = .loading
            fetchRandomJokes()
        case let .didLike(jokeId, liked):
            storeJokeLike(jokeId: jokeId, liked: liked)
            counter += 1
            if counter == state.jokes.count {
                send(.noMoreJokes)
            }
        case .noMoreJokes:
            eventSubject.send(.dismiss)
        }
    }
}

private extension SwipingViewStore {
    
    func fetchRandomJokes() {
        logger.info("thread: \(Thread.current.description)")
        Task {
            let (_, jokes) = try await self.jokesService.fetchJokes(number: 5, category: self.category)
            await send(.dataFetched(jokes))
        }
    }
    
    func storeJokeLike(jokeId: String, liked: Bool) {
        Task {
            try await self.store.storeLike(jokeId: jokeId, liked: liked)
        }
    }
}
