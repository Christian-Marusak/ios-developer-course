//
//  DataProvider.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Combine

enum HomeViewEvent {
    case itemTapped(Joke)
}

struct HomeViewState {
    
    enum Status {
        case initial
        case loading
        case ready
    }
    var status: Status = .initial
    var sections: [SectionData] = []
    
    static let initial = HomeViewState()
}

enum HomeViewAction {
    case viewDidLoad
    case didLike(Joke)
    case gotoSwaping(Joke)
    case dataFetched([SectionData], HomeViewState.Status)
}

typealias JokeCategoryRespose = (JokeCategory?, [Joke])

final class HomeViewStore: Store {
    
    @MainActor
    @Published var state: HomeViewState = .initial
    
    private let eventSubject = PassthroughSubject<HomeViewEvent, Never>()
    
    private let firebaseStore: StoreManaging
    private let jokeService: JokeServicing
    private let imageService: ImageServicing
    
    init(firebaseStore: StoreManaging, jokeService: JokeServicing, imageService: ImageServicing) {
        self.firebaseStore = firebaseStore
        self.jokeService = jokeService
        self.imageService = imageService
    }
    
    @MainActor
    func send(_ action: HomeViewAction) {
        switch action {
        case .viewDidLoad:
            state.status = .loading
            fetchData()
        case let .didLike(joke):
            storeLike(joke: joke)
        case let .gotoSwaping(joke):
            eventSubject.send(.itemTapped(joke))
        case let .dataFetched(sectionsData, status):
            state = HomeViewState(status: status, sections: sectionsData)
        }
    }
    
    private func fetchData() {
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
                    
                    await send(.dataFetched(sectionData, .loading))
                    let ids = Array(jokeIds)
                    try await self.getImagesForJokes(with: ids)
                    try await self.getLikesForJokes(with: ids)
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func getImagesForJokes(with ids: [String]) async throws {
        let imagesDict = try await imageService.downloadImagesFor(ids: ids)
        var data = await state.sections
        data.enumerated().forEach { index, section in
            let jokes = section.jokes.map {
                var joke = $0
                joke.image = imagesDict[joke.id]
                return joke
            }
            data[index].jokes = jokes
        }
        await send(.dataFetched(data, .loading))
    }
    
    private func getLikesForJokes(with ids: [String]) async throws {
        let likesDict = try await firebaseStore.getLikesForJokes(with: ids)
        var data = await state.sections
        data.enumerated().forEach { index, section in
            let jokes = section.jokes.map {
                var joke = $0
                joke.liked = likesDict[joke.id] ?? false
                return joke
            }
            data[index].jokes = jokes
        }
        await send(.dataFetched(data, .ready))
     }
    
    private func storeLike(joke: Joke) {
        Task {
            guard let liked = joke.liked else { return }
            try await firebaseStore.storeLike(jokeId: joke.id, liked: !liked)
            var data = await state.sections
            guard let sectionIndex = data.firstIndex(where: {$0.title == joke.categories.first}) else { return }
            var jokes = data[sectionIndex].jokes
            jokes.enumerated().forEach { i, j in
                if j.id == joke.id {
                    jokes[i].liked = !liked
                }
            }
            data[sectionIndex].jokes = jokes
            await send(.dataFetched(data, .ready))
        }
    }

}

// MARK: - EventEmitting
extension HomeViewStore: EventEmitting {
    var eventPublisher: AnyPublisher<HomeViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
