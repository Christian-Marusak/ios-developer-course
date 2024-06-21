//
//  SwipingViewAction.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import Foundation

enum SwipingViewAction {
    case viewDidLoad
    case didLike(String, Bool)
    case noMoreJokes
    case dataFetched([Joke])
}
