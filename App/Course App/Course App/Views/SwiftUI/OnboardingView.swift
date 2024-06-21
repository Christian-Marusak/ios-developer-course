//
//  OboardingView.swift
//  Course App
//
//  Created by Christián on 25/05/2024.
//

import SwiftUI
import UIKit
struct OnboardingView: View {
weak var coordinator: OnboardingNavigationCoordinator?
    let page: Int
    private var isLastPage: Bool {
        page == OnboardingNavigationCoordinator.numberOfPages - 1
    }
    
    var body: some View {
        Text("Currently you are on page \(page + 1)")
        Button(action: {
            coordinator?.pushNewPage(from: page)
        }, label: {
            Text("Move to \(isLastPage ? "first" : "next") screen")
        })
        if isLastPage {
            Button(action: {
//                coordinator?.close()
                coordinator?.handleDeepling(deeplink: .closeOnboarding)
            }, label: {
                Text("Close onboarding")
            })
        }
    }
}

//#Preview {
//    OnboardingView()
//}
