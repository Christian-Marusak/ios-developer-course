//
//  ContentView.swift
//  Course App
//
//  Created by Christián on 26/04/2024.
//

import SwiftUI

struct ContentView: View {
<<<<<<< Updated upstream:App/Course App/Course App/ContentView.swift
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
=======
    enum MagicNumbers: CGFloat {
        case numberTen = 10
        case numebrFive = 5
        
        func asCGFloat() -> CGFloat {
            CGFloat(self.rawValue)
        }
    }
    
    @StateObject private var dataProvider = MockDataProvider()
    let logger = Logger()
    var body: some View {
#if DEBUG
    ContentView._printChanges()
#endif
        
        return List {
            ForEach(dataProvider.data, id: \.self) { section in
                Section {
                    VStack {
                        ForEach(section.jokes) { joke in
                            ZStack(alignment: .bottomLeading, content: {
                                Image(uiImage: joke.image ?? UIImage())
                                    .resizableBordered(cornerRadius: MagicNumbers.numberTen.asCGFloat())
                                    .onTapGesture {
                                        debugPrint("Tapped joke \(joke)")
                                    }
                                imagePanel
                            })
                        }
                    }
                    .background(.bg)
                    .padding(.leading, MagicNumbers.numebrFive.asCGFloat())
                    .padding(.trailing, MagicNumbers.numebrFive.asCGFloat())
                } header: {
                    Text(section.title)
                        .foregroundStyle(.white)
                        .padding(.leading, MagicNumbers.numebrFive.asCGFloat())
                        .padding(.trailing, MagicNumbers.numebrFive.asCGFloat())
                }
                .background(.bg)
                .listRowInsets(EdgeInsets())
            }
>>>>>>> Stashed changes:App/Course App/Course App/Views/SwiftUI/ContentView.swift
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.bg)
    }
    private var imagePanel: some View {
        HStack {
            Text("Text")
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                debugPrint("Tapped button")
            } label: {
                Image(systemName: "heart")
            }
            .buttonStyle(SelectableButtonStyle(color: .gray, isSelected: .constant(true)))
        }
        .padding(MagicNumbers.numebrFive.rawValue)
    }
}

#Preview {
    ContentView()
}
