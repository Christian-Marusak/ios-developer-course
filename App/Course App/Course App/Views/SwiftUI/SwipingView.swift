//
//  SwipingView.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

import os
import SwiftUI

struct SwipingView: View {
    // MARK: - UIConstant
    private enum UIConstant {
        static let padding: CGFloat = 20
        static var cardWidthPadding: CGFloat {
            padding + padding
        }
        static let scale: CGFloat = 1.5
    }
    private let jokesService = JokeService(apiManager: APIManager())
    private let category: String?
    @State private var jokes: [Joke] = []
    // MARK: Private variables
    private let store = FirebaseStoreManager()

    init(joke: Joke? = nil) {
        self.category = joke?.categories.first
        if let joke {
            self.jokes.append(joke)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(jokes, id: \.self) { joke in
                        SwipingCard(
                            configuration: SwipingCard.Configuration(
                                title: joke.categories.first ?? "",
                                description: joke.text
                            ),
                            swipeStateAction: { action in
                                switch action {
                                case let .finished(direction):
                                    Task {
                                        try await self.store.storeLike(jokeId: joke.id, liked: direction == .left)
                                    }
                                default:
                                    break
                                }
                            }
                        )
                    }
                    .padding(.leading, UIConstant.padding)
                    .padding(.trailing, UIConstant.padding)
                    .padding(.top, UIConstant.cardWidthPadding)
                    .frame(
                        width: geometry.size.width - UIConstant.cardWidthPadding,
                        height: (geometry.size.width - UIConstant.cardWidthPadding) * UIConstant.scale
                    )
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onFirstAppear {
            fetchRandomJokes()
        }
        .navigationTitle("Random jokes")
        .embedInScrollViewIfNeeded()
    }

    func fetchRandomJokes() {
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) { group in
                for _ in 1...5 {
                    group.addTask {
                        if let category {
                            try await jokesService.fetchJokeForCategory(category)
                        } else {
                            try await jokesService.fetchRandomJoke()
                        }
                    }
                }

                for try await jokeResponse in group {
                    jokes.append(Joke(jokeResponse: jokeResponse, liked: false))
                }
            }
        }
    }
}

#Preview {
    SwipingView()
}
