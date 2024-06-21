//
//  NetworkingError.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation

enum NetworkingError: Error {
    case notLoggedIntUser
    case unacceptableStatusCode
    case noHttpResponse
    case decodingFailed(error: Error)
    case invalidUrlComponents
    case firestoreError(error: Error)
    case badImageData
}
