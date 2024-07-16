//
//  ProfileViewStore.swift
//  Course App
//
//  Created by Christián on 15/07/2024.
//
import Combine
import os
import Foundation

enum ProfileViewEvent {
    case logout
    case showOnboarding
}

final class ProfileViewStore: EventEmitting, Store {
    
    
    @Published var state: ProfileViewEvent = .showOnboarding
    @Published var name: String?
    let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    var authManager: FirebaseAuthManaging
    private var firebaseStoreManager: StoreManaging
    
    var eventPublisher: AnyPublisher<ProfileViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(authManager: FirebaseAuthManaging, firebaseStoreManager: StoreManaging) {
        self.authManager = authManager
        self.firebaseStoreManager = firebaseStoreManager
    }
    
    @MainActor
    func getLoggedUserName() async throws {
        let userDetails = try await firebaseStoreManager.fetchUserDetails()
        name = userDetails.name
    }
    
}
