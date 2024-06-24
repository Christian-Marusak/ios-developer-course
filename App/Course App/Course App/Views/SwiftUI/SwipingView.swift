//
//  SwipingView.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI

struct SwipingView: View {
    // MARK: - UIConstant
    private enum UIConstant {
        static let padding: CGFloat = 20
        static var cardWidthPadding: CGFloat {
            padding + padding
        }
        static let scale: CGFloat = 1.5
    }
    @StateObject private var store: SwipingViewStore
    private var joke: Joke?
    
    init(store: SwipingViewStore, joke: Joke?) {
        _store = .init(wrappedValue: store)
        self.joke = joke
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(store.state.jokes, id: \.self) { joke in
                        SwipingCard(
                            configuration: SwipingCard.Configuration(
                                title: joke.categories.first ?? "random",
                                description: joke.text
                            ),
                            swipeStateAction: { action in
                                switch action {
                                case let .finished(direction):
                                    store.send(.didLike(joke.id, direction == .right))
                                default:
                                    break
                                }
                            }
                        )
                    }
                    .padding(.leading, UIConstant.padding)
                    .padding(.trailing, UIConstant.padding)
                    .padding(.top, UIConstant.cardWidthPadding)
                    .frame(
                        width: geometry.size.width - UIConstant.cardWidthPadding,
                        height: (geometry.size.width - UIConstant.cardWidthPadding) * UIConstant.scale
                    )
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onFirstAppear {
            store.send(.viewDidLoad(joke))
        }
        .navigationTitle(joke == nil ? "Random jokes" : "\(joke!.categories.first ?? "Category") jokes")
        .embedInScrollViewIfNeeded()
    } 
    
}

//#Preview {
//    SwipingView()
//}
