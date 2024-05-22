//
//  SwipingView.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

struct SwipingView: View {
    enum MagicNumbers: CGFloat {
        case number20 = 20
        case number1point2 = 1.2
        case number1point5 = 1.5
        
        func asCGFloat() -> CGFloat {
            CGFloat(self.rawValue)
        }
        func asInt() -> Int {
            Int(self.rawValue)
        }
    }
    let dataProvider = MockDataProvider()
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                
                VStack {
                    if let jokes = dataProvider.data.first?.jokes {
                        ZStack {
                            ForEach(jokes, id: \.self) { joke in
                                SwipingCard(
                                    configuration: SwipingCard.Configuration(
                                        image: Image(uiImage: joke.image!),
                                        title: "category",
                                        description: joke.text
                                    ),
                                    swipeStateAction: { debugPrint( $0 ) }
                                )
                            }
                        }
                        .padding(.top, geometry.size.height / MagicNumbers.number20.rawValue)
                        .frame(width: geometry.size.width / MagicNumbers.number1point2.rawValue, height:
                        (geometry.size.width / MagicNumbers.number1point2.rawValue) * MagicNumbers.number1point5.rawValue)
                    } else {
                        Text("Empty data")
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SwipingView()
}
