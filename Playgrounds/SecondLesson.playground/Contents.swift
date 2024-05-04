//
// MARK: Optional Homework
//class City {
//    let numberOfCitizens: Int
//    let numberOfFamilies: Int
//    let cityName: String
//    
//    
//    init(numberOfCitizens: Int, numberOfCars: Int, numberOfFamilies: Int, cityName: String) {
//        self.numberOfCitizens = numberOfCitizens
//        self.numberOfFamilies = numberOfFamilies
//        self.cityName = cityName
//    }
//    
//    func QualityOfLifeBasedOnCars (numberOfCars: Int) {
//        
//        switch numberOfCars {
//        case 0 ... 1000:
//            print("Good quality, great is that u re using alternatives to tranportation")
//            
//        case 1001 ... 10000:
//            print("Not qreat, not terible, please just use more alternatives like bikes, public transports or electric scooters, earth will thank you later")
//            
//        case 10001...1000000:
//            print("Ou my god, stop IT! Please stop it till its late!!!")
//        
//        default: return print("i didnt catch your answer sorry")
//        }
//    }
//    
//    
//    enum Famielies {
//        case youngFamilies
//        case moreOlderNoYounger
//        case moreOlderThanYounger
//    }
//    
//
//    func BasedOnFamilies (famieliesInCity: Famielies) {
//        
//        switch famieliesInCity {
//        case .youngFamilies:
//                print("The city has a lot of young families. This is fantastic news! With more babies, the city will grow faster and attract more investment, leading to job opportunities for everyone.")
//                
//            case .moreOlderNoYounger:
//                print("The city has more older people than younger ones. While this presents some challenges, it also means there's an opportunity to create programs and initiatives to attract younger residents and revitalize the community.")
//                
//            case .moreOlderThanYounger:
//                print("The city's population skews older compared to younger residents. This demographic trend suggests the need for policies and investments in healthcare, eldercare, and pension systems to support the aging population.")
//        }
//    }
//                                
//}
//
//
//
//let bratislavaCity: City = City(numberOfCitizens: 10000, numberOfCars: 1050, numberOfFamilies: 10000, cityName: "Bratislava")
//
//bratislavaCity.QualityOfLifeBasedOnCars(numberOfCars: 15234)
//
//bratislavaCity.BasedOnFamilies(famieliesInCity: .moreOlderNoYounger)
//
//
//
//
//struct PayAsYouRide {
//    
//    enum Salary {
//        case junior, medior, senior
//    }
//    
//    static func payByKmAndSalary (salaryNumber: Salary, payPerKilometer: Double, kilometersYouDone: Int) -> Double {
//
//        let result: Double
//
//        switch salaryNumber {
//            
//        case .junior:
//            result = 1.38 * Double(payPerKilometer + Double(kilometersYouDone))
//            
//        case .medior:
//            result = 1.68 * Double(payPerKilometer + Double(kilometersYouDone))
//            
//        case .senior:
//            result = 2.12 * Double(payPerKilometer + Double(kilometersYouDone))
//        }
//        print(result)
//        return result
//        
//    }
//}
//
//
//
//
//var myRide = PayAsYouRide.payByKmAndSalary(salaryNumber: .medior, payPerKilometer: 0.15, kilometersYouDone: 15)
//
//
//
//class PayAsYouRide2 {
//    
//    enum Salary {
//        case junior, medior, senior
//    }
//    
//    static func payByKmAndSalary (salaryNumber: Salary, payPerKilometer: Double, kilometersYouDone: Int) -> Double {
//
//        let result: Double
//
//        switch salaryNumber {
//            
//        case .junior:
//            result = 1.38 * Double(payPerKilometer + Double(kilometersYouDone))
//            
//        case .medior:
//            result = 1.68 * Double(payPerKilometer + Double(kilometersYouDone))
//            
//        case .senior:
//            result = 2.12 * Double(payPerKilometer + Double(kilometersYouDone))
//        }
//        print(result)
//        return result
//        
//    }
//}
//
//
//
//
//var myRide2 = PayAsYouRide2.payByKmAndSalary(salaryNumber: .senior, payPerKilometer: 1.5, kilometersYouDone: 14)
//
//MARK: On the 3. Lesson
//
//
//Double.pi
//
//
//
//import SwiftUI
//
//protocol Shape {
//    func area() -> Double
//}
//
//struct Circle: Shape {
//    var radius: Double
//
//    func area() -> Double {
//        .pi * radius * radius
//    }
//}
//
//struct Rectangle: Shape {
//    var width: Double
//    var height: Double
//
//    func area() -> Double {
//        width * height
//    }
//}
//
//func createSomeShape() -> some Shape {
//    Rectangle(width: 2.0, height: 2.0)
//    return Circle(radius: 1.0)
//}
//
//func createAnyShape(isCircle: Bool) -> any Shape {
//    if isCircle {
//        Circle(radius: 1.0)
//    } else {
//        Rectangle(width: 1.0, height: 1.0)
//    }
//}

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
