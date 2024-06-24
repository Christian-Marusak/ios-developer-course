//  ResizableBordered.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

public enum CornerRadiusSize: CGFloat {
    case `default` = 10
    case extra = 15
}

extension Image {
    public func resizableBordered(_ cornerRadius: CGFloat = CornerRadiusSize.default.rawValue) -> some View {
        self
            .resizable()
            .scaledToFill()
            .bordered(cornerRadius: cornerRadius)
    }
}
