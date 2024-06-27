//
//  KeychainTests.swift
//  App Course Unit Tests
//
//  Created by Christián on 25/06/2024.
//

@testable import App_Course_Dev
import XCTest

final class KeychainServiceTests: XCTestCase {
    var mockKeychainManager: MockKeychainManager!
    var keychainService: KeychainService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockKeychainManager = MockKeychainManager()
        keychainService = KeychainService(keychainManager: mockKeychainManager)
    }

    override func tearDownWithError() throws {
        mockKeychainManager = nil
        keychainService = nil
        try super.tearDownWithError()
    }

    func testAuthDataKeychainServiceFlow() throws {
        try keychainService.storeAuthData(authData: "tested")
        let fetchAuthTokenFromKeychain = try keychainService.fetchAuthData()
        logger.info("Printing out content of \(fetchAuthTokenFromKeychain)")
        XCTAssertTrue(fetchAuthTokenFromKeychain == "tested")
        try keychainService.removeAuthData()
        XCTAssertThrowsError(try keychainService.fetchAuthData())
    }
    
    func testLoginDataFlow() throws {
        try keychainService.storeLogin("myStoredLogin")
        let fetchLoginFromKeychain = try keychainService.fetchLogin()
        XCTAssertTrue(fetchLoginFromKeychain == "myStoredLogin")
        try keychainService.removeLoginData()
        XCTAssertThrowsError(try keychainService.fetchLogin())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
