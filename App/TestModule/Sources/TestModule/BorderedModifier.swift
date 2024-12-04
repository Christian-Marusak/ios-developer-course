//
//  BorderedModifier.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

public struct BorderedModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var number2: CGFloat = 2
    
    public func body(content: Content) -> some View {
        content
            .background(.gray)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke( Color.white, lineWidth: number2)
            )
            .shadow(radius: number2)
    }
}

extension View {
    public func bordered(cornerRadius: CGFloat) -> some View {
        self.modifier(BorderedModifier(cornerRadius: cornerRadius))
    }
}
