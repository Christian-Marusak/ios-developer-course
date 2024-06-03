//
//  SwipingView.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

struct SwipingView: View {
    let dataProvider = MockDataProvider()
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                
                VStack{
                    
                    if let jokes = dataProvider.data.first?.jokes {
                        ZStack {
                            ForEach(jokes, id: \.self) { joke in
                                SwipingCard(
                                    configuration: SwipingCard.Configuration(
                                        image: Image(uiImage:joke.image!),
                                        title: "category",
                                        description: joke.text
                                    ),
                                    swipeStateAction: {print ($0)}
                                )
                            }
                        }
                        .padding(.top, geometry.size.height / 20)
                        .frame(width: geometry.size.width / 1.2, height: (geometry.size.width / 1.2) * 1.5)
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
