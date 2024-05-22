//
//  ScratchView.swift
//  Course App
//
//  Created by Christián on 20/05/2024.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 50.0
}

struct ScratchView: View {
    // MARK: Variables
    let image: Image
    let text: String
    
    enum MagicNumbers: CGFloat {
        case number10 = 10
        case number1point2 = 1.2
        case number1point5 = 1.5
        
        func asCGFloat() -> CGFloat {
            CGFloat(self.rawValue)
        }
        func asInt() -> Int {
            Int(self.rawValue)
        }
    }
    
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
    var body: some View {
        ZStack(alignment: .top) {
            image
                .resizableBordered(cornerRadius: MagicNumbers.number10.rawValue)
                .scaledToFit()
            
            RoundedRectangle(cornerRadius: MagicNumbers.number10.rawValue)
                .fill(.bg)
                .overlay {
                    Text(text)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .mask(
                    Canvas { context, _ in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(
                                path, with: .color(.white), style: StrokeStyle(
                                    lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round
                                )
                            )
                        }
                    }
                )
                .gesture(dragGesture)
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged { value in
                let newPoint = value.location
                currentLine.points.append(newPoint)
                lines.append(currentLine)
            }
    }
}

#Preview {
    ScratchView(image: Image("nature"), text: "Joke")
}
