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
    //MARK: Variables
    
    let text: String
    
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            if let url = try?
                           ImagesRouter.size300x200.asURLRequest().url {
                           AsyncImage(url: url) { image in
                               image.resizableBordered(cornerRadius: 3)
                                   .scaledToFit()
                           } placeholder: {
                               Color.gray
                           }
                       } else {
                           Text("ERROR MESSAGE")
                       }
            
            RoundedRectangle(cornerRadius: 10 )
                .fill(.bg)
                .overlay {
                    Text(text)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .mask (
                    Canvas { context, _ in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round)
                            )
                        }
                    }
                )
                .gesture(dragGesture)
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0,coordinateSpace: .local)
            .onChanged { value in
                let newPoint = value.location
                currentLine.points.append(newPoint)
                lines.append(currentLine)
            }
    }
}

#Preview {
    ScratchView(text: "Joke")
}
