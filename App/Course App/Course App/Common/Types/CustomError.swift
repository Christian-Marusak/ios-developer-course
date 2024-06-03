//
//  CustomError.swift
//  Course App
//
//  Created by Christián on 03/06/2024.
//

import Foundation
import os

var logger: Logger = Logger()

enum CustomError: Error {
    case networkError(message: String)
    case unknownError

        var localizedDescription: String {
            switch self {
            case .networkError(let message):
                logger.error("Network Error: \(message)")
                return ("Network Error: \(message)")
            case .unknownError:
                logger.error("Unknown Error:")
                return ("Unknown Error:")
            }
        }
}
