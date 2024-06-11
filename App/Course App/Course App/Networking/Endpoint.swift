//
//  Endpoint.swift
//  Course App
//
//  Created by Christián on 06/06/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var host: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlParameters: [String: String] { get }
    
    func asURLRequest() throws -> URLRequest
}


extension Endpoint {
    var method: HTTPMethod  {
        .get
    }
    
    var headers: [String: String] {
        [:]
    }
    var urlParameters: [String: String] {
        [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = host.appendingPathComponent(path)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkingError.invadilURLComponents
        }
        
        if !urlParameters.isEmpty {
            urlComponents.queryItems = urlParameters.map{
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }
        
        guard let url = urlComponents.url else  {
            throw NetworkingError.invadilURLComponents
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        request.setValue(HTTPHeader.ContentType.json.rawValue, forHTTPHeaderField: HTTPHeader.HeaderField.contentType.rawValue)
        
        return request
    }
}

enum NetworkingError: Error {
    case unacceptableStatusCode
    case noHttpResponse
    case decodingFailed(error: Error)
    case invadilURLComponents
}

enum HTTPHeader {
    enum HeaderField: String {
        case contentType = "Content-Type"
    }
    
    enum ContentType: String  {
        case json = "application/json"
        case text = "text/html;charset=utf-8"
    }
}
