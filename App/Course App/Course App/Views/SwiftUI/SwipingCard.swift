//
//  SwipingCard.swift
//  Course App
//
//  Created by Christián on 19/05/2024.
//

import SwiftUI
typealias Action<T> = (T) -> Void

struct SwipingCard: View {
    // MARK: - SwipeDirection
    enum SwipeDirection {
        case left
        case right
    }

    // MARK: - SwipeState
    enum SwipeState {
        case swiping(direction: SwipeDirection)
        case finished(direction: SwipeDirection)
        case cancelled
    }

    // MARK: - Configuration
    struct Configuration: Equatable {
        let title: String
        let description: String
    }

    // MARK: - UI constant
    private enum UIConstant {
        static let opacity: CGFloat = 0.7
        static let backgroundColor: Color = .bg.opacity(opacity)
        static let scratchViewSizeScale: CGFloat = 0.5
        static let rotationEffect: CGFloat = 40
        static let baseSwipeOpacity: CGFloat = 0.6
    }

    // MARK: - Swipe weight
    private enum SwipeWeight {
        static let swipeDetection: CGFloat = 60
        static let minSwipe: CGFloat = 200
        static let maxSwipe: CGFloat = 500
    }

    // MARK: Private variables
    private let swipingAction: Action<SwipeState>
    private let configuration: Configuration
    @State private var offset: CGSize = .zero
    @State private var color: Color = UIConstant.backgroundColor

    init(
        configuration: Configuration,
        swipeStateAction: @escaping (Action<SwipeState>)
    ) {
        self.configuration = configuration
        self.swipingAction = swipeStateAction
    }

    // MARK: View
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ScratchView(
                    text: configuration.description
                )
                .frame(height: geometry.size.height * UIConstant.scratchViewSizeScale)
                Spacer()
                cardDescription
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(color)
        .cornerRadius(CornerRadiusSize.default.rawValue)
        .offset(x: offset.width, y: offset.height * UIConstant.scratchViewSizeScale)
        .rotationEffect(.degrees(Double(offset.width / UIConstant.rotationEffect)))
        .gesture(dragGesture)
    }

    // MARK: Drag gesture
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

    // MARK: CardDescription
    private var cardDescription: some View {
        Text(configuration.title)
            .textTypeModifier(textType: .futuraTitle)
            .cornerRadius(CornerRadiusSize.default.rawValue)
            .padding()
    }
}

// MARK: - Swipe logic
private extension SwipingCard {
    func finishSwipe(translation: CGSize) {
        // swipe left
        if -SwipeWeight.maxSwipe...(-SwipeWeight.minSwipe) ~= translation.width {
            offset = CGSize(
                width: -SwipeWeight.maxSwipe,
                height: 0
            )
            swipingAction(.finished(direction: .left))
        } else if SwipeWeight.minSwipe...SwipeWeight.maxSwipe ~= translation.width {
            // swipe right
            offset = CGSize(
                width: SwipeWeight.maxSwipe,
                height: 0
            )
            swipingAction(.finished(direction: .right))
        } else {
            // re-center
            offset = .zero
            color = UIConstant.backgroundColor
            swipingAction(.cancelled)
        }
    }

    func swiping(translation: CGSize) {
        // swipe left
        if translation.width < -SwipeWeight.swipeDetection {
            color = .red
                .opacity(countOpacity(offset: translation.width))
            swipingAction(.swiping(direction: .left))
        } else if translation.width > SwipeWeight.swipeDetection {
            // swipe right
            color = .green
                .opacity(countOpacity(offset: translation.width))
            swipingAction(.swiping(direction: .right))
        } else {
            color = UIConstant.backgroundColor
            swipingAction(.cancelled)
        }
    }

    func countOpacity(offset: Double) -> CGFloat {
        Double(abs(offset) / SwipeWeight.maxSwipe) + UIConstant.baseSwipeOpacity
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        SwipingCard(
            configuration: SwipingCard.Configuration(
                title: "Card Title",
                description: "This is a short description. This is a short description. This is a short description. This is a short description. This is a short description."
            ),
            swipeStateAction: { _ in }
        )
        .previewLayout(.sizeThatFits)
    }
}
