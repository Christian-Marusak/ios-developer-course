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
    
    weak var deeplinkHandler: AppCoordinator?
   
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
//    deeplinkFromService()
    return true
}
    
    func deeplinkFromService() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.deeplinkHandler?.handleDeepling(deeplink: .onboarding(page: 2))
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
//            self?.deeplinkHandler?.handleDeepling(deeplink: .closeOnboarding)
//        }
    }
    
}

@main
// swiftlint:disable:next type_name
struct Course_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var appCoordinator: AppCoordinator
    
    private let logger = Logger()
    
    init() {
        FirebaseApp.configure()
        appCoordinator = AppCoordinator()
        appCoordinator.start()
        delegate.deeplinkHandler = appCoordinator
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: appCoordinator)
                .id(appCoordinator.isAuthorizedFlow)
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    logger.info("Content view has appeared")
                }
        }
    }
    
//    @ViewBuilder var rootView: some View {
//        if appCoordinator.isAuthorizedFlow {
//            CoordinatorView(coordinator: appCoordinator)
//        } else {
//            CoordinatorView(coordinator: appCoordinator)
//        }
//    }
}

