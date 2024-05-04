//MARK: 3. Lesson Homework

import SwiftUI

protocol EventType {
    var name: String { get }
}


protocol AnalyticEvent {
associatedtype Event: EventType
  var type: Event { get }
  var parameters: [String: Any] { get }
}


extension AnalyticEvent {
    var name: String {
        type.name
    }
}

struct ScreenViewEvent: EventType {
    private(set) var name: String
}

struct UserActionEvent: EventType {
    private(set) var name: String
}

struct ScreenViewEventAnalytic: AnalyticEvent {
    typealias Event = ScreenViewEvent
    
    private(set) var type: ScreenViewEvent
    private(set) var parameters: [String : Any]
}

struct UserActionEventAnalytic: AnalyticEvent {
    typealias Event = UserActionEvent
    
    private(set) var type: UserActionEvent
    private(set) var parameters: [String : Any]
}

protocol AnalyticService {
    func logEvent(_ event: any AnalyticEvent)
}


class Analyzer: AnalyticService {
    
    private var events: [any AnalyticEvent] = []
    
    func logEvent(_ event: any AnalyticEvent) {
        
        
        printEvent(event)
        events.append(event)
    }
    
   private func printEvent(_ event: any AnalyticEvent) {
        
       print("Logging event \(event.name) with parameters \(event.parameters) of type \(type(of: event))")
        
    }
    
    func printLoggedEvents() {
        for event in events {
            printEvent(event)
        }
    }
}

let analyzer = Analyzer()
let eventOne = UserActionEventAnalytic(type: UserActionEvent(name: "Buy an apple"), parameters: ["price" : 2])
analyzer.logEvent(eventOne)
let eventTwo = ScreenViewEventAnalytic(type: ScreenViewEvent(name: "Show warning"), parameters: ["destructive" : Color.red ])
analyzer.logEvent(eventTwo)

analyzer.printLoggedEvents()

let userActionEventNames = ["buy an apple", "turn on GPS", "turn on flashlight", "start battery saving mode", "start shortcut"]
let screenViewEventNames = ["show warning", "show dasboard", "show userDetailView", "show settings", "open app"]

let keysForAction = ["performance","memory", "optimization"]

let colorsForScreen = [Color.red, Color.blue, Color.green]
let keysForScreen = ["interactive", "destructive", "basic", "withButton"]



for _ in 0...99 {
    var eventAnalytic: any AnalyticEvent
    if Int.random(in: 0...1) == 0 {
        
        let eventPosition = Int.random(in: 0..<userActionEventNames.count)
        let keyPosition = Int.random(in: 0..<keysForAction.count)
        
        let event = UserActionEvent(name: userActionEventNames[eventPosition])
        
        eventAnalytic = UserActionEventAnalytic(type: event, parameters: [keysForAction[keyPosition] : Int.random(in: 1...10)])
        
    } else {
        let eventPosition = Int.random(in: 0..<screenViewEventNames.count)
        let colorPosition = Int.random(in: 0..<colorsForScreen.count)
        let keyPosition = Int.random(in: 0..<keysForScreen.count)
        
        let event = ScreenViewEvent(name: screenViewEventNames[eventPosition])
        
        eventAnalytic = ScreenViewEventAnalytic(type: event, parameters: [ keysForScreen[keyPosition] : colorsForScreen[colorPosition]])
    }
    analyzer.logEvent(eventAnalytic)
}

print()
analyzer.printLoggedEvents()
