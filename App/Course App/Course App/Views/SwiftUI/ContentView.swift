//
//  ContentView.swift
//  Course App
//
//  Created by Christián on 26/04/2024.
//
import os
import SwiftUI

struct ContentView: View {
    enum MagicNumbers: CGFloat {
        case numberTen = 10
        case numebrFive = 5
        
        func asCGFloat() -> CGFloat {
            return CGFloat(self.rawValue)
        }
    }
    
    @StateObject var dataProvider = MockDataProvider()
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
                print("Tapped button")
            } label: {
                Image(systemName: "heart")
            }
            .buttonStyle(SelectableButtonStyle(color: .gray , isSelected: .constant(true)))
        }
        .padding(5)
    }
}

#Preview {
    ContentView()
}
