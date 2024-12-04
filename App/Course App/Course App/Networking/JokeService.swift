//
//  JokeService.swift
//  Course App
//
//  Created by Christián on 11/06/2024.
//

import Foundation

protocol JokesServicing {
    var apiManager: APIManaging { get }
    
    func fetchCategories() async throws -> [String]
    func fetchRandomJoke() async throws -> JokeResponse
    func fetchJokeForCategory(_ category: String) async throws -> JokeResponse
}

final class JokeService: JokesServicing {
    let apiManager: APIManaging
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}

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
}
