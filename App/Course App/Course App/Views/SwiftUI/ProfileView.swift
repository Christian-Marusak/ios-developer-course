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
    
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    
    var body: some View {
        Text("Profile View")
        Button(action: {
            eventSubject.send(.showOnboarding)
        }, label: {
            Text("Start onboarding inside profile view")
        })
        Button(action: {
            eventSubject.send(.logout)
            UserDefaults.standard.set(false, forKey: Constants.isAuthorizedFlowKey)
        }, label: {
            Text("Logout")
        })
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
