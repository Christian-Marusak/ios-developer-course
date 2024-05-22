//
//  SelectableButtonStyle.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

struct SelectableButtonStyle: ButtonStyle {
    var color: Color
    @Binding var isSelected: Bool
    
    enum MagicNumbers: Double {
        case number10 = 10
        case numeber8 = 8
        case point5 = 0.5
        case point8 = 0.8
        case number1 = 1.0
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(MagicNumbers.number10.rawValue)
            .background(color.opacity(MagicNumbers.point5.rawValue))
            .foregroundColor(isSelected ? Color.red : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: MagicNumbers.numeber8.rawValue))
            .scaleEffect(configuration.isPressed ? MagicNumbers.point8.rawValue : MagicNumbers.number1.rawValue)
            .animation(.easeInOut, value: isSelected)
            .animation(.easeInOut, value: configuration.isPressed)
            .contentShape(Rectangle())
    }
}
