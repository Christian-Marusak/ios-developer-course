//
//  JokeServiceTest.swift
//  App Course Unit Tests
//
//  Created by Christián on 25/06/2024.
//

import XCTest
@testable import App_Course_Dev

final class JokeServiceTest: XCTestCase {

    var mockApiManager: MockApiManager!
    var jokeService: JokeService!
    
    override func setUpWithError() throws {
        try super.tearDownWithError()
        mockApiManager = MockApiManager()
        jokeService = JokeService(apiManager: mockApiManager)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testFetchCategories() async throws {
        mockApiManager.mockData = MockDataResponses.mockCategoriesResponse
        let categories = try await jokeService.fetchCategories()
        XCTAssert(categories.count == 2, "Doesnt fit expectd number of fetched categories")
        XCTAssert(categories.contains(where: {$0 == "funny"}))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
