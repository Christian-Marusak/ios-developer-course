//
//  ProfileView.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import SwiftUI

struct ProfileView: View {
    
    weak var coordinator: OnboardingNavigationCoordinator?
    
    var body: some View {
        Text("Profile View")
        Button(action: {
            self.coordinator?.handleDeepling(deeplink: .onboarding(page: 1))
        }, label: {
            Text("Start onboarding")
        })
    }
}

#Preview {
    ProfileView()
}
