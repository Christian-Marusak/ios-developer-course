//
//  ProfileView.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import SwiftUI

struct ProfileView: View {
    
//    var coordinator: ProfileNavigationCoordinator?
    
    var body: some View {
        Text("Profile View")
        Button(action: {
//            ProfileNavigationCoordinator().
        }, label: {
            Text("Start onboarding inside profile view")
        })
    }
}

#Preview {
    ProfileView()
}
