//
//  EmbedInScrollView.swift
//  Course App
//
//  Created by Christián on 14/06/2024.
//

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

