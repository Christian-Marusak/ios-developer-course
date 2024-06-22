//
//  CoordinatorView.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import SwiftUI
import UIKit

struct CoordinatorView<T: ViewControllerCoordinator>: UIViewControllerRepresentable {
    
    let coordinator: T
    func makeUIViewController(context: Context) -> some UIViewController {
        coordinator.rootViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
