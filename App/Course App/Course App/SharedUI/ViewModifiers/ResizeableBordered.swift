//  ResizableBordered.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

extension Image {
    func resizableBordered(cornerRadius: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .bordered(cornerRadius: cornerRadius)
    }
}
