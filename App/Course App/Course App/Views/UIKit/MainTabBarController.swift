//
//  MainTabBarController.swift
//  Course App
//
//  Created by Christián on 21/05/2024.
//

import SwiftUI
import UIKit

//struct MainTabView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> MainTabBarController {
//        MainTabBarController()
//    }
//    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
//}

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalNavigationBar()
        setupGlobalTabBarUI()
//        setupTabBar()
    }
}

// MARK: UI Setup
private extension MainTabBarController {
    func setupTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .red
        tabBar.tintColor = .blue
    }
    func setupGlobalTabBarUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .black
    }
    func setupGlobalNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28), .foregroundColor: UIColor.blue]
    }

}
