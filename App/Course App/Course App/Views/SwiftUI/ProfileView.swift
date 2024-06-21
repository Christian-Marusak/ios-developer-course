//
//  ProfileView.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import SwiftUI
import UIKit
import Combine

enum ProfileViewEvent {
    case logout
    case showOnboarding
}

struct ProfileView: View {
    
    @State var name: String?
    
    private var authManager: FirebaseAuthManaging = FirebaseAuthManager()
    private var storeManager: FirebaseStoreManager = FirebaseStoreManager()
    
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    
    var body: some View {
        Text(name ?? "Profile View").font(.title)
        Button(action: {
            eventSubject.send(.showOnboarding)
        }, label: {
            Text("Start onboarding inside profile view")
        })
        Button(action: {
            Task {
                do {
                    try await authManager.signOut()
                } catch {
                    logger.info("Logout failed with error \(error.localizedDescription)")
                }
                eventSubject.send(.logout)
            }
        }, label: {
            Text("Logout")
        }).onFirstAppear {
            Task {
                try await getLoggedUserName()
            }
        }
    }
    
}

private extension ProfileView {
    @MainActor
    func getLoggedUserName() async throws {
        let userDetails = try await storeManager.fetchUserDetails()
        name = userDetails.name
    }
}

extension ProfileView: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    ProfileView()
}
