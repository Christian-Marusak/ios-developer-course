//
//  KeychainManager.swift
//  Course App
//
//  Created by Christián on 03/06/2024.
//

import UIKit
import KeychainAccess



//class MockKeychainManager: KeychainManaging {
//    func store(key: String, value: some Encodable) throws {
//        keychain[data: key] = try encoder.encode(value)
//    }
//}

protocol KeychainServicing {
    func storeAuthData(authData: String) throws
    func removeAuthData() throws
}

class KeychainService: KeychainServicing {
    var keychainManager: KeychainManaging
    func storeAuthData(authData: String) throws {
        try keychainManager.store(key: "authDataByApp", value: authData)
    }
    
    func removeAuthData() throws {
        try keychainManager.remove(key: "authDataByApp")
    }
    
    init(keychainManager: KeychainManaging) {
        self.keychainManager = keychainManager
    }
}

protocol KeychainManaging {
    func store<T: Encodable>(key: String, value: T) throws
    func fetch<T: Decodable>(key: String) throws -> T
    func remove(key: String) throws
}

class KeychainManager: KeychainManaging {

    private let keychain = Keychain()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func store(key: String, value: some Encodable) throws {
        keychain[data: key] = try encoder.encode(value)
    }
    
    func fetch<T>(key: String) throws -> T where T : Decodable {
        guard let data = try keychain.getData(key) else { throw CustomError.noDataError }
        return try decoder.decode(T.self, from: data)
    }
    
    func remove(key: String) throws {
        try keychain.remove(key)
    }
    
}
