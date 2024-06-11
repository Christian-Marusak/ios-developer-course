//
//  EventEmittier.swift
//  Course App
//
//  Created by Christián on 26/05/2024.
//

import Combine

protocol EventEmitting {
    associatedtype Event
    
    var eventPublisher: AnyPublisher<Event, Never> { get }
}
