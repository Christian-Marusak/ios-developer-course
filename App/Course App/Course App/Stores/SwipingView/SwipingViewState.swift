//
//  SwipingViewState.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import Foundation

struct SwipingViewState {
    
    enum Status {
        case initial
        case loading
        case ready
    }
    var status: Status = .initial
    var jokes: [Joke] = []
    
    static let initial = SwipingViewState()
}
