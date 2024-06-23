//
//  EmbedInScrollView.swift
//  Course App
//
//  Created by Christián on 14/06/2024.
//

import SwiftUI

public struct EmbedInScrollView: ViewModifier {
    public func body(content: Content) -> some View {
        ViewThatFits {
            content

            ScrollView {
                content
            }
        }
    }
}

extension View {
    public func embedInScrollViewIfNeeded() -> some View {
        modifier(EmbedInScrollView())
    }
}

