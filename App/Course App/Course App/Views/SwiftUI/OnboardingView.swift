//
//  OboardingView.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    let coordinator = OnboardingNavigationCoordinator()
    
    var body: some View {
        Text("Currently you are on page")
        Button(action: {
            
        }, label: {
            Text("Move to next screen")
        })
    }
}

#Preview {
    OnboardingView()
}
