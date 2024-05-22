//
//  Course_AppApp.swift
//  Course App
//
//  Created by Christián on 26/04/2024.
//

<<<<<<< Updated upstream
import SwiftUI

=======
import FirebaseCore
import os
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
    FirebaseApp.configure()

    return true
}
}


>>>>>>> Stashed changes
@main
struct Course_AppApp: App {
<<<<<<< Updated upstream
    var body: some Scene {
        WindowGroup {
            ContentView()
=======
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let logger = Logger()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    logger.info("Content view has appeared")
                }
>>>>>>> Stashed changes
        }
    }
}
