//
//  DataProvider.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import FirebaseFirestore

protocol DataProvider: ObservableObject {
    var data: [SectionData] { get set }
}

typealias JokeCategoryRespose = (JokeCategory?, [Joke])

final class RealDataProvider: DataProvider, ObservableObject {
    
    @Published var data: [SectionData] = []
    
    private let store = FirebaseStoreManager()
    private let jokeService: JokeServicing = JokeService(apiManager: APIManager())
    private let imageService = ImageService(apiManager: APIManager())
    
    @MainActor
    func fetchData() {
        Task {
            let categories = try await jokeService.fetchCategories()
            do {
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
                    let ids = Array(jokeIds)
                    try await self.getLikesForJokes(with: ids)
                    try await self.getImagesForJokes(with: ids)
                } 
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func getImagesForJokes(with ids: [String]) async throws {
        let imagesDict = try await imageService.downloadImagesFor(ids: ids)
        var data = self.data
        data.enumerated().forEach { index, section in
            let jokes = section.jokes.map {
                var joke = $0
                joke.image = imagesDict[joke.id]
                return joke
            }
            data[index].jokes = jokes
        }
        self.data = data
    }
    
    private func getLikesForJokes(with ids: [String]) async throws {
        let likesDict = try await store.getLikesForJokes(with: ids)
        var data = self.data
        data.enumerated().forEach { index, section in
            let jokes = section.jokes.map {
                var joke = $0
                joke.liked = likesDict[joke.id] ?? false
                return joke
            }
            data[index].jokes = jokes
        }
        self.data = data
    }
    
    @MainActor
    func storeLike(joke: Joke) {
        Task {
            guard let liked = joke.liked else { return }
            try await store.storeLike(jokeId: joke.id, liked: !liked)
            guard let sectionIndex = data.firstIndex(where: {$0.title == joke.categories.first}) else { return }
            var jokes = data[sectionIndex].jokes
            jokes.enumerated().forEach { i, j in
                if j.id == joke.id {
                    jokes[i].liked = !liked
                }
            }
            data[sectionIndex].jokes = jokes
        }
    }

}
