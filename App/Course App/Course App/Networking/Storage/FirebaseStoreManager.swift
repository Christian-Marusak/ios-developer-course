//
//  FirebaseStoreManager.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import FirebaseFirestore
import Foundation
import os

struct UserDetails {
    let name: String?
}

protocol StoreManaging {
    func storeLike(jokeId: String, liked: Bool) async throws
    func fetchLiked(jokeId: String) async throws -> Bool
    func getLikesForJokes(with ids: [String]) async throws -> [String: Bool]
    func store(userDetails: UserDetails) async throws
    func fetchUserDetails() async throws -> UserDetails
}

final class FirebaseStoreManager: StoreManaging {
    private let database = Firestore.firestore()
    private let authManager = FirebaseAuthManager()
    private let logger = Logger()

    func storeLike(jokeId: String, liked: Bool) async throws {
        do {
            try await database.collection("users").document(try authManager.getCurrentUserID())
                .collection("jokeLikes").document(jokeId).setData([
                    "jokeId": jokeId,
                    "liked": liked
                ])
            logger.info("Document successfully written!")
        } catch {
            logger.info("Error writing document: \(error)")
            throw NetworkingError.firestoreError(error: error)
        }
    }

    func fetchLiked(jokeId: String) async throws -> Bool {
        let docRef = database.collection("users").document(try authManager.getCurrentUserID())
            .collection("jokeLikes").document(jokeId)
        do {
            let document = try await docRef.getDocument()
            logger.info("Reading document: \(document.data()?.description ?? "")")
            if let liked = document.data()?["liked"] as? Bool {
                return liked
            }
        } catch {
            logger.info("Error reading document: \(error)")
            throw NetworkingError.firestoreError(error: error)
        }
        return false
    }
    
    func getLikesForJokes(with ids: [String]) async throws -> [String: Bool] {
        let ref = database.collection("users").document(try authManager.getCurrentUserID())
            .collection("jokeLikes")
//        let query = ref.whereField("jokeId", in: [ids])
        let snapshot = try await ref.getDocuments()

        var result: [String: Bool] = [:]
           
        snapshot.documents.forEach { document in
            result[document.documentID] = document["liked"] as? Bool ?? false
        }
        
        return result
    }
    
    func store(userDetails: UserDetails) async throws {
        do {
            try await database.collection("users").document(try authManager.getCurrentUserID())
                .setData(["name" : userDetails.name ?? ""], merge: true)
        } catch {
            throw NetworkingError.firestoreError(error: error)
        }
    }
    
    func fetchUserDetails() async throws -> UserDetails {
        let userDocRef = database.collection("users").document(try authManager.getCurrentUserID())
        do {
            let document = try await userDocRef.getDocument()
            return UserDetails(name: document["name"] as? String)
        } catch {
            throw NetworkingError.firestoreError(error: error)
        }
    }
    
}
