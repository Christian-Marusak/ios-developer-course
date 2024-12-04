//
//  Store.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import Foundation

protocol Store: ObservableObject {
    associatedtype State
    associatedtype Action

    @MainActor var state: State { get }

    @MainActor func send(_ action: Action)
}
