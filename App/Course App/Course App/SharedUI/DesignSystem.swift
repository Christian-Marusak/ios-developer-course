//
//  DesignSystem.swift
//  Course App
//
//  Created by Christián on 21/05/2024.
//

import SwiftUI
import UIKit

enum FontSize: CGFloat {
    case size36 = 36
    case size28 = 28
    case size20 = 20
    case size12 = 12
    case size18 = 18
}

enum FontType: String {
    case regular = "Poppins-Regular"
    case bold = "Poppins-Bold"
    case mediumItalic = "Poppins-MediumItalic"
    case futura = "Futura-MediumItalic"
}
struct TextTypeModifier: ViewModifier {
    let textType: TextType
    func body(content: Content) -> some View {
        content
            .font(textType.font)
            .foregroundColor(textType.color)
    }
}

struct TextColorModifier: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .bold()
    }
}


enum TextType {
    case baseText
    case h1Title
    case futuraTitle
    case h2Title
    
    var font: Font {
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
    
    var color: Color {
        switch self {
        case .h1Title:
    .black
        default:
    .gray
        }
    }
}

extension UIFont {
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
extension Font {
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

extension View {
    func textTypeModifier(textType: TextType) -> some View {
        self.modifier(TextTypeModifier(textType: textType))
    }
    
    func textColorBoldModifier(color: Color) -> some View {
        self.modifier(TextColorModifier(color: color))
    }
}
