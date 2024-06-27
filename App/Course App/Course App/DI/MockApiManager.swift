//
//  MockApiManager.swift
//  App Course UITests
//
//  Created by Christián on 25/06/2024.
//

import Foundation

enum MockError: Error {
    case noMockDataError
}

final class MockApiManager: APIManaging {
    
    var apiError: NetworkingError?
    var mockData: Data?
    
    func request<T>(_ endpoint: any App_Course_Dev.Endpoint) async throws -> T where T : Decodable {
        if let apiError {
            
        }
        if let data = mockData {
            let decode = JSONDecoder()
            decode.dateDecodingStrategy = .iso8601
            return try decode.decode(T.self, from: data)
        } else {
            throw MockError.noMockDataError
        }
    }
}
