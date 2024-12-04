//
//  CancellablesContaining.swift
//  Course App
//
//  Created by Christián on 21/06/2024.
//

import Combine

protocol CancellablesContaining: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}
