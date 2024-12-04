//
//  onFirstAppear.swift
//  Course App
//
//  Created by Christián on 14/06/2024.
//

import SwiftUI

typealias VoidAction = () -> Void

public struct OnFirstAppear: ViewModifier {
    // MARK: Private variables
    @State var viewDidAppear = false
    let action: VoidAction?

    // MARK: Lifecycle
    init(perform action: VoidAction? = nil) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if !viewDidAppear {
                viewDidAppear = true

                action?()
            }
        }
    }
}

public extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(
            OnFirstAppear(perform: action)
        )
    }
}
