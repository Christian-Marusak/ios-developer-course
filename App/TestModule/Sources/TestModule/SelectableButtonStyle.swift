//
//  SelectableButtonStyle.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

enum PaddingSize: CGFloat {
    case `default` = 10
    case extra = 15
}

public struct SelectableButtonStyle: ButtonStyle {
    
    public init(isSelected: Binding<Bool?>, color: Color) {
            _isSelected = .init(projectedValue: isSelected)
            self.color = color
        }
    
    // MARK: - UI constants
    enum StyleConstant {
        static let opacity: CGFloat = 0.5
        static let scaleEffectMin: CGFloat = 0.7
        static let scaleEffectMax: CGFloat = 1
    }

    // MARK: Public variables
    @Binding var isSelected: Bool?
    var color: Color

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(PaddingSize.default.rawValue)
            .background(color.opacity(StyleConstant.opacity))
            .foregroundColor(isSelected == nil ? .clear : isSelected! ? .red : .white)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusSize.default.rawValue))
            .scaleEffect(configuration.isPressed ? StyleConstant.scaleEffectMin : StyleConstant.scaleEffectMax)
            .animation(.easeInOut, value: isSelected)
            .animation(.easeInOut, value: configuration.isPressed)
            .contentShape(Rectangle())
    }

}
