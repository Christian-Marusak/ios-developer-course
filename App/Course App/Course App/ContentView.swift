//
//  ContentView.swift
//  Course App
//
//  Created by Christián on 26/04/2024.
//
import os
import SwiftUI

struct ContentView: View {
    let fontSize: CGFloat = 50
    let configuration = Configuration.default
    let logger = Logger()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(Font.custom("Poppins-Regular", size: fontSize))
        }.onAppear {
            logger.info("View appeared")
            logger.info("Our configuration is \(String(describing: configuration))")
            let identifier: String = "[SYSTEM FONTS]"
            for family in UIFont.familyNames as [String] {
                debugPrint("\(identifier) FONT FAMILY : \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    debugPrint("\(identifier) FONT NAME : \(name)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
