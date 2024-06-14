//
//  ApiManager.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation
import os

// MARK: - Protocol
protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Implementation
final class APIManager: APIManaging {
    // MARK: Private properties
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30

        return URLSession(configuration: config)
    }()
    private lazy var logger = Logger()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"

        return formatter
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        return decoder
    }()
}

extension APIManager {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.info("Decoding error \(error)")
            throw NetworkingError.decodingFailed(error: error)
        }
    }
}

private extension APIManager {
    func request(_ endpoint: Endpoint) async throws -> Data {
        let request: URLRequest = try endpoint.asURLRequest()

        logger.info("🚀 Request for \"\(request.description)\"")

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.noHttpResponse
        }

        try checkStatusCode(httpResponse)

        // Uncomment this for pretty response logging!
        let body = String(decoding: data, as: UTF8.self)
        logger.info("""
            ☀️ Response for \"\(request.description)\":
            👀 Status: \(httpResponse.statusCode)
            🧍‍♂️ Body:
            \(body)
            """)

        return data
    }

    func checkStatusCode(_ urlResponse: HTTPURLResponse) throws {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw NetworkingError.unacceptableStatusCode
        }
    }
}

