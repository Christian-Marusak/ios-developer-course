//
//  SwipingCard.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI
typealias Action<T> = (T) -> Void
struct SwipingCard: View {
    
    enum SwipeDirection {
        case left
        case right
    }
    
    enum SwipeState {
        case swiping(direction: SwipeDirection)
        case finished(direction: SwipeDirection)
        case cancelled
    }
    
    //MARK: Config
    public struct Configuration: Equatable {
        let image: Image
        let title: String
        let description: String
        
        public init(
            image: Image,
            title: String,
            description: String
        ) {
            self.image = image
            self.title = title
            self.description = description
        }
    }
    private let swipingAction: Action<SwipeState>
    private let configuration: Configuration
    @State private var offset: CGSize = .zero
    @State private var color: Color = .black.opacity(0.7)
    
    public init(configuration: Configuration, swipeStateAction: @escaping (Action<SwipeState>)) {
        
        self.configuration = configuration
        self.swipingAction = swipeStateAction
    }
//MARK: View
    
    var body: some View {
        HStack {
             Spacer()
            VStack{
                Spacer()
                    //scratchView
                ScratchView(image: configuration.image, text: configuration.description)
                Spacer()
                cardDescription
            }
            Spacer()
        }
        .background(color)
        .cornerRadius(15)
        .offset(x: offset.width, y: offset.height * 0.5)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(dragGesture)
    }
    
    //MARK: Drag Gesture
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation {
                    swiping(translation: offset)
                }
            }
            .onEnded { _ in
                withAnimation {
                    finishSwipe(translation: offset)
                }
            }
    }
    
    //MARK: Card Description
    private var cardDescription: some View {
        Text(configuration.title)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .padding(10)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
            .padding()
    }
}


//MARK: Swipe Logic
private extension SwipingCard {
    func finishSwipe(translation: CGSize) {
        // swipe left
        if -500...(-200) ~= translation.width {
            offset = CGSize(width: -500, height: 0)
            swipingAction(.finished(direction: .left))
        } else if 200...500 ~= translation.width  { //swipe right
            offset = CGSize(width: 500, height: 0)
            swipingAction(.finished(direction: .right))
        } else {
            offset = .zero
            color = .bg.opacity(0.7)
            swipingAction(.cancelled)
        }
    }
    
    func swiping(translation: CGSize) {
        //swipe left
        if translation.width < -60 {
            color = .green
                .opacity(Double(abs(translation.width) / 500) + 0.6)
            swipingAction(.swiping(direction: .left))
        } else if translation.width > 60 {
                color = .red
                    .opacity(Double(translation.width / 500) + 0.6) //swipe right
            swipingAction(.swiping(direction: .right))
        } else {
            color = .bg.opacity(0.7)
            swipingAction(.cancelled)
        }
    }
}







struct Card_Previews: PreviewProvider {
    static var previews: some View {
        SwipingCard(
            configuration: SwipingCard.Configuration(
                image: Image("nature"),
                title: "Card Title",
                description: "This is a short description. This is a short description. This is a short description. This is a short description. This is a short description."
            ),
            swipeStateAction: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .frame(width: 220, height: 340)
    }
}
