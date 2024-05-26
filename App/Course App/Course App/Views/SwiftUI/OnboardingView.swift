//
//  OboardingView.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    let coordinator = AppCoordinator()
    var page: Int = 0
    
    var body: some View {
        Text("Currently you are on page \(page)")
        Button(action: {
            coordinator.handleDeepling(deeplink: .onboarding(page: 3))
        }, label: {
            Text("Move to next screen")
        })
    }
}

#Preview {
    OnboardingView()
}
