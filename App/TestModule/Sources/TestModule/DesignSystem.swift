//
//  DesignSystem.swift
//  Course App
//
//  Created by Christián on 21/05/2024.
//

import SwiftUI
import UIKit

public enum FontType: String {
    case regular = "Poppins-Regular"
    case bold = "Poppins-Bold"
    case mediumItalic = "Poppins-MediumItalic"
    case futura = "Futura-MediumItalic"
}
public struct TextTypeModifier: ViewModifier {
    public let textType: TextType
    public func body(content: Content) -> some View {
        content
            .font(textType.font)
            .foregroundColor(textType.color)
    }
}

public struct TextColorModifier: ViewModifier {
    let color: Color
    public func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .bold()
    }
}


public enum TextType {
    case baseText
    case h1Title
    case futuraTitle
    case h2Title
    
    public var font: Font {
        switch self {
        case .baseText:
                .regular(with: .size18)
        case .h1Title:
    .bold(with: .size36)
        case .futuraTitle:
    .futura(with: .size28)
        case .h2Title:
    .regular(with: .size20)
        }
    }
    
    public var color: Color {
        switch self {
        case .h1Title:
    .black
        default:
    .gray
        }
    }
}

public extension UIFont {
    static func regular(with size: FontSize) -> UIFont {
        UIFont(name: FontType.regular.rawValue, size: size.rawValue)!
    }
    static func bold(with size: FontSize) -> UIFont {
        UIFont(name: FontType.bold.rawValue, size: size.rawValue)!
    }
    static func futura(with size: FontSize) -> UIFont {
        UIFont(name: FontType.futura.rawValue, size: size.rawValue)!
    }
}
public extension Font {
    static func regular(with size: FontSize) -> Font {
        Font.custom(FontType.regular.rawValue, size: size.rawValue)
    }
    static func bold(with size: FontSize) -> Font {
        Font.custom(FontType.bold.rawValue, size: size.rawValue)
    }
    static func futura(with size: FontSize) -> Font {
        Font.custom(FontType.futura.rawValue, size: size.rawValue)
    }
}

public extension View {
    func textTypeModifier(textType: TextType) -> some View {
        self.modifier(TextTypeModifier(textType: textType))
    }
    
    func textColorBoldModifier(color: Color) -> some View {
        self.modifier(TextColorModifier(color: color))
    }
}
