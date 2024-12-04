//
//  JokeResponse.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation

typealias JokeCategory = String

struct JokeResponse: Codable {
    let id: String
    let categories: [JokeCategory]
    let createdAt: Date
    let url: URL
    let value: String
}
