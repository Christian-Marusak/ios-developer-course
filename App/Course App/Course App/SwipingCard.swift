//
//  SwipingCard.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI
typealias Action<T> = (T) -> Void
struct SwipingCard: View {
    enum MagicNumbers: CGFloat {
        case number10 = 10
        case number5 = 5
        case number8 = 8
        case number3 = 3
        case number4 = 4
        case number30 = 30
        case numberPoint7 = 0.7
        case numberPoint5 = 0.5
        case numberPoint6 = 0.6
        case number15 = 15
        case number40 = 40
        case number500 = 500
        case number200 = 200
        case number60 = 60
    }
    
    enum SwipeDirection {
        case left
        case right
    }
    
    enum SwipeState {
        case swiping(direction: SwipeDirection)
        case finished(direction: SwipeDirection)
        case cancelled
    }
    
    // MARK: Config
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
    @State private var color: Color = .black.opacity(MagicNumbers.numberPoint7.rawValue)
    
    public init(configuration: Configuration, swipeStateAction: @escaping (Action<SwipeState>)) {
        self.configuration = configuration
        self.swipingAction = swipeStateAction
    }
// MARK: View
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                    // scratchView
                ScratchView(image: configuration.image, text: configuration.description)
                Spacer()
                cardDescription
            }
            Spacer()
        }
        .background(color)
        .cornerRadius(MagicNumbers.number15.rawValue)
        .offset(x: offset.width, y: offset.height * MagicNumbers.numberPoint5.rawValue)
        .rotationEffect(.degrees(Double(offset.width / MagicNumbers.number40.rawValue)))
        .gesture(dragGesture)
    }
    
    // MARK: Drag Gesture
    
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
    
    // MARK: Card Description
    private var cardDescription: some View {
        Text(configuration.title)
            .foregroundStyle(.white)
            .textTypeModifier(textType: .h2Title)
            .padding(MagicNumbers.number10.rawValue)
            .background(Color.black.opacity(MagicNumbers.numberPoint5.rawValue))
            .cornerRadius(MagicNumbers.number10.rawValue)
            .padding()
    }
}


// MARK: Swipe Logic
private extension SwipingCard {
    func finishSwipe(translation: CGSize) {
        // swipe left
        if -MagicNumbers.number500.rawValue...(-MagicNumbers.number200.rawValue) ~= translation.width {
            offset = CGSize(width: -MagicNumbers.number500.rawValue, height: .zero)
            swipingAction(.finished(direction: .left))
        } else if MagicNumbers.number200.rawValue...MagicNumbers.number500.rawValue ~= translation.width { // swipe right
            offset = CGSize(width: MagicNumbers.number500.rawValue, height: .zero)
            swipingAction(.finished(direction: .right))
        } else {
            offset = .zero
            color = .bg.opacity(MagicNumbers.numberPoint7.rawValue)
            swipingAction(.cancelled)
        }
    }
    
    func swiping(translation: CGSize) {
        // swipe left
        if translation.width < -MagicNumbers.number60.rawValue {
            color = .green
                .opacity(Double(abs(translation.width) / MagicNumbers.number500.rawValue) + MagicNumbers.numberPoint6.rawValue)
            swipingAction(.swiping(direction: .left))
        } else if translation.width > MagicNumbers.number60.rawValue {
            color = .red
                .opacity(Double(translation.width / MagicNumbers.number500.rawValue) + MagicNumbers.numberPoint6.rawValue) // swipe right
            swipingAction(.swiping(direction: .right))
        } else {
            color = .bg.opacity(MagicNumbers.numberPoint7.rawValue)
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
