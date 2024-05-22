//
//  HeaderView.swift
//  Course App
//
//  Created by Christián on 22/05/2024.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let padding: CGFloat = 10
    var body: some View {
        HStack {
            Text(title)
                .textColorBoldModifier(color: .white)
                .textTypeModifier(textType: .futuraTitle)
                .padding([.top, .leading], padding)
            Spacer()
        }
    }
}

#Preview {
    HeaderView(title: "Test")
}
