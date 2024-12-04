//
//  ProfileView.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import SwiftUI
import UIKit
import Combine
import TestModule



struct ProfileView: View {
    @StateObject private var store: ProfileViewStore
    
    init(store: ProfileViewStore) {
        _store = .init(wrappedValue: store)
    }
    
    var body: some View {
        Text(store.name ?? "Profile View").font(.title)
        Button(action: {
            store.eventSubject.send(.showOnboarding)
        }, label: {
            Text("Start onboarding modal")
        })
        Button(action: {
            Task {
                do {
                    try await store.authManager.signOut()
                } catch {
                    logger.info("Logout failed with error \(error.localizedDescription)")
                }
                store.eventSubject.send(.logout)
            }
        }, label: {
            Text("Logout")
        }).onFirstAppear {
            Task {
                try await store.getLoggedUserName()
            }
        }
    }
    
}
