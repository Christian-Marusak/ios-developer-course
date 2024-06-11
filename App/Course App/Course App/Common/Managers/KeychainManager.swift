//
//  KeychainManager.swift
//  Course App
//
//  Created by Christián on 03/06/2024.
//

import UIKit
import KeychainAccess

protocol KeychainManaging {
    func store<T: Encodable>(key: String, value: T) throws
    func fetch<T: Decodable>(key: String) throws -> T
    func remove(key: String) throws
}


final class KeychainService: KeychainServicing {
    enum KeychainKey: String {
        case authData = "com.course.app.authData"
    }

    private(set) var keychainManager: KeychainManaging

    init(keychainManager: KeychainManaging) {
        self.keychainManager = keychainManager
    }

    func storeAuthData(authData: String) throws {
        try keychainManager.store(key: KeychainKey.authData.rawValue, value: authData)
    }

    func fetchAuthData() throws -> String {
        try keychainManager.fetch(key: KeychainKey.authData.rawValue)
    }

    func removeAuthData() throws {
        try keychainManager.remove(key: KeychainKey.authData.rawValue)
    }
}

protocol KeychainServicing {
    var keychainManager: KeychainManaging { get }

    func storeAuthData(authData: String) throws
    func fetchAuthData() throws -> String
    func removeAuthData() throws
}

final class KeychainManager: KeychainManaging {
    private let keychain = Keychain()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func store(key: String, value: some Encodable) throws {
        keychain[data: key] = try encoder.encode(value)
    }

    func fetch<T>(key: String) throws -> T where T: Decodable {
        guard let data = try keychain.getData(key) else {
            throw KeychainManagerError.dataNotFound
        }

        return try decoder.decode(T.self, from: data)
    }

    func remove(key: String) throws {
        try keychain.remove(key)
    }
}


enum KeychainManagerError: LocalizedError {
    /// Couldn't find data under specified key.
    case dataNotFound

    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            "Data for key not found"
        }
    }
}
