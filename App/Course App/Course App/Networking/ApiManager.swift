//
//  ApiManager.swift
//  Course App
//
//  Created by Christián on 10/06/2024.
//

import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}


final class APIManager: APIManaging {
    
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
    
    func request<T>(_ endpoint: any Endpoint) async throws -> T where T : Decodable {
            let data = try await request(endpoint )
        
        
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.info("Decoder failer with error \(error)")
            throw NetworkingError.decodingFailed(error: error)
        }
    }
    func request(_ endpoint: Endpoint) async throws -> Data {
        let request: URLRequest = try endpoint.asURLRequest()
        
        logger.info("Request for \"\(request.description)\"")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.noHttpResponse
        }
        
        try checkStatusCode(httpResponse)
        
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
