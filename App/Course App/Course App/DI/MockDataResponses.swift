//
//  MockDataResponses.swift
//  App Course UITests
//
//  Created by Christián on 25/06/2024.
//

import Foundation

enum MockDataResponses {
    static let mockJokeResponse =
    """
    {
        "id": "12345",
        "categories": ["programming", "funny"],
        "created_at": "2024-06-18T12:00:00Z",
        "url": "https://api.example.com/jokes/12345",
        "value": "Why do programmers prefer dark mode? Because light attracts bugs!"
    }
    """.data(using: .utf8)!

    static let mockCategoriesResponse =
    """
    [
        "programming", "funny"
    ]
    """.data(using: .utf8)!
}
