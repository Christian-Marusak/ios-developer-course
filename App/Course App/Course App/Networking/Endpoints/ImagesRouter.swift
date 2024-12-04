//
//  ImagesRouter.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import Foundation

enum ImagesRouter: Endpoint {
    case size300x200

    var host: URL {
        BuildConfiguration.default.apiImagesBaseURL
    }

    var path: String {
        "300/200"
    }
}
