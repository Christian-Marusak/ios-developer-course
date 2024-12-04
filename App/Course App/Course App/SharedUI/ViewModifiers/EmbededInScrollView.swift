//
//  EmbededInScrollView.swift
//  Course App
//
//  Created by Christián on 11/06/2024.
//

import Foundation
import SwiftUI

private struct EmbedInScrollView: ViewModifier {
    func body(content: Content) -> some View {
        ViewThatFits {
            content

            ScrollView {
                content
            }
        }
    }
}

extension View {
    func embedInScrollViewIfNeeded() -> some View {
        modifier(EmbedInScrollView())
    }
}
