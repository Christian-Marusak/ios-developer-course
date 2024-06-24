//
//  MockDataProvider.swift
//  Course App
//
//  Created by Christián on 13/05/2024.
//

import Foundation

import UIKit

let mockImages = [
    UIImage.nature,
    UIImage.computer,
    UIImage.food
]

struct SectionData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    var jokes: [Joke]
}

struct Joke: Identifiable, Hashable {
    var id = UUID().uuidString
    let text: String
    var image: UIImage?
    var categories: [String] = []
    var liked: Bool?
}

extension Joke {
    init(jokeResponse: JokeResponse, liked: Bool?) {
        self.id = jokeResponse.id
        self.text = jokeResponse.value
        self.categories = jokeResponse.categories
        self.liked = liked
    }
}

final class MockDataProvider: ObservableObject {
    @Published var data: [SectionData]
    // MARK: Data
    private var localData = [
        SectionData(
            title: "Celebrations",
            jokes: [
                Joke(
                    text: "Chuck Norris can make hamburger out of ham."
                ),
                Joke(
                    text: "All your base are belong to Chuck Norris"
                ),
                Joke(
                    text: "Chuck Norris can hit a barn door with a broad's side."
                )
            ]
        )
    ]
    
    init() {
        data = localData
        //        updateData()
    }
}

// MARK: - Private methods
private extension MockDataProvider {
    func updateData() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 4
        ) {
            if var section = self.localData.first {
                section.jokes.remove(at: 1)
                self.data = [section]
            }
        }
    }
}
