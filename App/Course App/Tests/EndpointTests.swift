//
//  EndpointTests.swift
//  App Course Unit Tests
//
//  Created by Christián on 25/06/2024.
//

import XCTest
@testable import App_Course_Dev

final class EndpointTests: XCTestCase {

    enum MockEndpoint: Endpoint {
        case mockMethodGet
        case mockMethodPost
        case mockGetParameter

        var host: URL {
            URL(string: "https://example.com)")!
        }

        var path: String {
            "api/test/path"
        }

        var method: HTTPMethod {
            switch self {
            case .mockGetParameter, .mockMethodGet:
                    .get
            case .mockMethodPost:
                    .post
            }
        }
    }

    func testHttpMethod() throws {
        guard let urlRequestGet = try? MockEndpoint.mockGetParameter.asURLRequest() else {
            XCTFail("can't create url request")
            return
        }

        XCTAssert(urlRequestGet.httpMethod == HTTPMethod.get.rawValue)

        guard let urlRequestPost = try? MockEndpoint.mockMethodPost.asURLRequest() else {
            XCTFail("can't create url request")
            return
        }

        XCTAssert(urlRequestPost.httpMethod == HTTPMethod.post.rawValue)
    }
}
