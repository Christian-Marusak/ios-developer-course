//
//  KeychainManager.swift
//  Course App
//
//  Created by Christián on 03/06/2024.
//
//
//import UIKit
//import KeychainAccess
//
//protocol KeychainManaging {
//    func store<T: Encodable>(key: String, value: T) throws
//    func fetch<T: Decodable>(key: String) throws -> T
//    func remove(key: String) throws
//}
//
//class MockKeychainManager: KeychainManaging {
//    func store(key: String, value: some Encodable) throws {
//        keychain[data: key] = try encoder.encode(value)
//    }
//}
//
//class KeychainService: KeychainServicing {
//    let keychainManager: KeychainManaging = KeychainManager()
//    func storeAuthData(authData: String) {
//        keychainManager.store(key: "authDataByApp", value: authData)
//    }
//}
//
//protocol KeychainServicing {
//    func storeAuthData(authData: String)
//}
//
//class KeychainManager: KeychainManaging {
//    private let keychain = Keychain()
//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//    
//    func store(key: String, value: some Encodable) throws {
//        keychain[data: key] = try encoder.encode(value)
//    }
//    
//    
//}
