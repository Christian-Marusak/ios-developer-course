//
//  ProfileView.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    
    let coordinator: ProfileNavigationCoordinator = ProfileNavigationCoordinator()
    
    var body: some View {
        Text("Profile View")
        Button(action: {
            coordinator.handleDeepling(deeplink: .onboarding(page: 0))
        }, label: {
            Text("Start onboarding inside profile view")
        })
    }
}

#Preview {
    ProfileView()
}
