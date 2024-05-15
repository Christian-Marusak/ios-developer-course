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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
