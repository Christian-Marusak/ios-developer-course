//
//  DataProvider.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation

protocol DataProvider: ObservableObject {
    var data: [SectionData] { get set }
}

typealias JokeCategoryRespose = (JokeCategory?, [Joke])

final class RealDataProvider: DataProvider, ObservableObject {
    @Published var data: [SectionData] = []
    
    var jokeIds: Set<String> = [] {
        didSet {
            setupJokeLikesListener(with: Array(jokeIds))
        }
    }
    
    private let store: StoreManaging = FirebaseStoreManager()
    private let jokeService: JokeServicing = JokeService(apiManager: APIManager())
    
    @MainActor
    func fetchData() {
        Task {
            let categories = try await jokeService.fetchCategories()

            try await withThrowingTaskGroup(of: JokeCategoryRespose.self) { [weak self] group in
                guard let self else {
                    return
                }
                
                
                categories.forEach { category in
                    group.addTask {
                        try await self.jokeService.fetchJokes(number: 5, category: category)
                    }
                }
                
                var sectionData: [SectionData] = []
                var jokeIds: Set<String> = []
                for try await (category, jokes) in group {
                    jokes.forEach { jokeIds.insert($0.id) }
                    sectionData.append(SectionData(title: category ?? "", jokes: jokes))
                }
                
                data = sectionData
                self.jokeIds = jokeIds
            }
        }
    }
    
    func setupJokeLikesListener(with ids: [String]) {
        do {
            try store.createLikesListener(jokeIds: ids) { [weak self] likes in
                guard var data = self?.data else { return }
//                data.enumerated().forEach{ index, section in
//                    
//                }
            }
        } catch {
            
        }
    }
    
    
}
