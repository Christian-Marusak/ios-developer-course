//
//  MainTabBarController.swift
//  Course App
//
//  Created by Christián on 21/05/2024.
//

import Foundation
import SwiftUI
import UIKit


struct MainTabView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        MainTabBarController()
    }
    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}
final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalNavigationBar()
        setupGlobalTabBarUI()
//        setupTabBar()
    setupTabBarControllers()
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
        UITabBar.appearance().tintColor = .white
    }
    func setupGlobalNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28), .foregroundColor: UIColor.blue]
    }
    
    func setupTabBarControllers() {
        viewControllers = [setupCategoriesView(), setupSwipingCardView()]
    }
    
    
    func setupCategoriesView() -> UIViewController {
        let categoriesNavigationController = UINavigationController(rootViewController: HomeViewController())
        categoriesNavigationController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.dash.header.rectangle"), tag: 0)
        
        
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .brown
//        appearance.shadowImage = UIImage()
//        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28)]
//        
//        categoriesNavigationController.navigationBar.standardAppearance = appearance
//        categoriesNavigationController.navigationBar.compactAppearance = appearance
//        categoriesNavigationController.navigationBar.scrollEdgeAppearance = appearance
//        categoriesNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(with: .size28)]
        
    return categoriesNavigationController
    }
    
    func setupSwipingCardView() -> UIViewController {
        let vcon = UIHostingController(rootView: SwipingView())
        vcon.title = "Scratch view"
        let swipingNavigationController = UINavigationController(rootViewController: vcon )
        
        swipingNavigationController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        swipingNavigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.blue], for: .normal)
//        swipingNavigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold(with: .size20), .foregroundColor: UIColor.red], for: .selected)
        
    let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futura(with: .size28)]
        
        swipingNavigationController.navigationBar.standardAppearance = appearance
        swipingNavigationController.navigationBar.compactAppearance = appearance
        swipingNavigationController.navigationBar.scrollEdgeAppearance = appearance
        
        
        return swipingNavigationController
    }
}
