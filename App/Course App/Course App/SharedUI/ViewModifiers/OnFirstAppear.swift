//
//  OnFirstAppear.swift
//  Course App
//
//  Created by Christián on 11/06/2024.
//

import Foundation
import SwiftUI

private struct OnFirstAppear: ViewModifier {
    // MARK: Private variables
    @State private var viewDidAppear = false
    private let action: VoidAction?

    // MARK: Lifecycle
    init(perform action: VoidAction? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if !viewDidAppear {
                viewDidAppear = true

                action?()
            }
        }
    }
}

extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(
            OnFirstAppear(perform: action)
        )
    }
}
