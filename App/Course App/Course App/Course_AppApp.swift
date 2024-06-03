//
//  Course_AppApp.swift
//  Course App
//
//  Created by Christián on 26/04/2024.
//

import FirebaseCore
import UIKit
import SwiftUI
import os
//
enum Deeplink {
    case onboarding(page: Int)
    case closeOnboarding
    case signIn
}

class AppDelegate: NSObject, UIApplicationDelegate {
   
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
    FirebaseApp.configure()
        deeplinkFromService()
    return true
}
    
    func deeplinkFromService() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            self?.appCoordinator.handleDeepling(deeplink: .onboarding(page: 2))
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
//            self?.appCoordinator.handleDeepling(deeplink: .closeOnboarding)
//        }
    }
    
}


@main
// swiftlint:disable:next type_name
struct Course_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var appCoordinator = AppCoordinator()
    
    private let logger = Logger()
    
    init() {
        appCoordinator.start()
    }
    
    var body: some Scene {
        WindowGroup {
            rootView
                .ignoresSafeArea(edges: .all)
                .onAppear{
                    logger.info("Content view has appeared")
                }
        }
    }
    
    @ViewBuilder var rootView: some View {
        if appCoordinator.isAuthorizedFlow {
            CoordinatorView(coordinator: appCoordinator)
        } else {
            CoordinatorView(coordinator: appCoordinator)
        }
    }
}

