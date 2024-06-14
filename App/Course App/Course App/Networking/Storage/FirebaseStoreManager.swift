//
//  FirebaseStoreManager.swift
//  Course App
//
//  Created by Christián on 13/06/2024.
//

import FirebaseFirestore
import Foundation
import os

protocol StoreManaging {
    func storeLike(jokeId: String, liked: Bool) async throws
    func fetchLiked(jokeId: String) async throws -> Bool
    func createLikesListener(jokeIds: [String], callBack: @escaping Action<[String: Bool]>) throws
}

final class FirebaseStoreManager: StoreManaging {
    private let database = Firestore.firestore()
    private let authManager = FirebaseAuthManager()
    private let logger = Logger()
    private var likesListener: ListenerRegistration?
    

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
        }
        return false
    }
    
    func createLikesListener(jokeIds: [String], callBack: @escaping Action<[String: Bool]>) throws {
        likesListener?.remove()
        let ref = database.collection("users").document(try authManager.getCurrentUserID())
            .collection("jokeLikes")
        let query = ref.whereField("jokeId", in: [jokeIds])
        likesListener = query.addSnapshotListener { snapshot, _ in
            guard let snapshot else { return }
            var result: [String: Bool] = [:]
            
            snapshot.documents.forEach { document in
                result[document.documentID] = document["liked"] as? Bool ?? false
            }
            
            callBack(result)
        }
    }
    
    
}

