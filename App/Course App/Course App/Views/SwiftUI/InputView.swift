//
//  InputView.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import SwiftUI

struct InputView: View {
    
    @State var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color.gray)
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text).font(.system(size: 14))
            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: "Text", title: "Title", placeholder: "Placeholder")
}
