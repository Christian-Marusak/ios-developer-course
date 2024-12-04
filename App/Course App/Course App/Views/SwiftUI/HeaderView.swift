//
//  HeaderView.swift
//  Course App
//
//  Created by Christián on 24/05/2024.
//

import SwiftUI

struct HeaderView: View {
    
    var title: String
    
    var body: some View {
        HStack{
        
            Text(title)
                .textColorBoldModifier(color: .white)
                .textTypeModifier(textType: .futuraTitle)
            Spacer()
        }.padding([.top,.leading], 10)
    }
}

#Preview {
    HeaderView(title: "Test")
}
