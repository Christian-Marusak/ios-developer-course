//
//  JokeService.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation

protocol JokeServicing {
    var apiManager: APIManaging { get }

    func fetchCategories() async throws -> [String]
    func fetchRandomJoke() async throws -> JokeResponse
    func fetchJokeForCategory(_ category: String) async throws -> JokeResponse
    func fetchJokes(number: Int, category: JokeCategory?) async throws -> (JokeCategory?, [Joke])
}

final class JokeService: JokeServicing {
    let apiManager: APIManaging

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}

// MARK: - Functions
extension JokeService {
    func fetchRandomJoke() async throws -> JokeResponse {
        try await apiManager.request(JokesRouter.getRandomJoke)
    }

    func fetchJokeForCategory(_ category: String) async throws -> JokeResponse {
        try await apiManager.request(JokesRouter.getJokeFor(category: category))
    }

    func fetchCategories() async throws -> [String] {
        try await apiManager.request(JokesRouter.getJokeCategories)
    }
    
    func fetchJokes(number: Int, category: JokeCategory?) async throws -> (JokeCategory?, [Joke]) {
        try await withThrowingTaskGroup(of: JokeResponse.self) { [weak self] group in
            guard let self else {
                return (category, [])
            }
            for _ in 1...number {
                group.addTask {
                    if let category {
                        try await self.fetchJokeForCategory(category)
                    } else {
                        try await self.fetchRandomJoke()
                    }
                }
            }
            var jokes: [Joke] = []
            
            for try await jokeResponse in group {
                let joke = Joke(
                    id: jokeResponse.id,
                    text: jokeResponse.value,
                    categories: jokeResponse.categories,
                    liked: nil
                    )
                jokes.append(joke)
            }
            
            return (category, jokes)
        }
    }
}

