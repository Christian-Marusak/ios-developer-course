//import UIKit
//
//func addFunction(num1: Int, num2: Int) -> Int {
//    let result: Int?
//    result = num1 + num2
//    
//    return result ?? 0
//}
//let finalResult = addFunction(num1: 1, num2: 2)
//print(finalResult)
//
//let addClosure: ((Int, Int) -> (Int)) = {number1, number2 in
//    let result = number1 + number2
//    
//    return result
//}
//
//var finalResult1 = addClosure(1, 2)
//
//print(finalResult)
//
//
//private func nonEscapingClosure(results:(String) -> Void ) {
//    print("Closure starts")
//    results("Closure called")
//    print("Closure ended")
//}
//
//nonEscapingClosure(results: {string in
//    print("Hello")
//})
//
//print("Next clsure")
//
//private func escapignClosure(results: @escaping(String) -> Void ) {
//    print(" esc Closure starts")
//    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//        results("esc Closure called")
//     
//    }
//    print(" esc Closure ended")
//}
//
//escapignClosure(results: {string in
//print(" esc Hello")
//})
//
//print(" esc Next closure")
//
//
//
//class Circle {
//
//    let name: String
//    var radius: Double?
//    var area: Double {
//        guard let radius else { return 0 }
//        return Double.pi * radius * radius
//    }
//    init(name: String, radius: Double? = nil) {
//        self.name = name
//        self.radius = radius
//    }
//}


class City {
    let numberOfCitizens: Int
    let numberOfFamilies: Int
    let cityName: String
    
    
    init(numberOfCitizens: Int, numberOfCars: Int, numberOfFamilies: Int, cityName: String) {
        self.numberOfCitizens = numberOfCitizens
        self.numberOfFamilies = numberOfFamilies
        self.cityName = cityName
    }
    
    func QualityOfLifeBasedOnCars (numberOfCars: Int) {
        
        switch numberOfCars {
        case 0 ... 1000:
            print("Good quality, great is that u re using alternatives to tranportation")
            
        case 1001 ... 10000:
            print("Not qreat, not terible, please just use more alternatives like bikes, public transports or electric scooters, earth will thank you later")
            
        case 10001...1000000:
            print("Ou my god, stop IT! Please stop it till its late!!!")
        
        default: return print("i didnt catch your answer sorry")
        }
    }
    
    
    enum Famielies {
        case youngFamilies
        case moreOlderNoYounger
        case moreOlderThanYounger
    }
    

    func BasedOnFamilies (famieliesInCity: Famielies) {
        
        switch famieliesInCity {
        case .youngFamilies:
                print("The city has a lot of young families. This is fantastic news! With more babies, the city will grow faster and attract more investment, leading to job opportunities for everyone.")
                
            case .moreOlderNoYounger:
                print("The city has more older people than younger ones. While this presents some challenges, it also means there's an opportunity to create programs and initiatives to attract younger residents and revitalize the community.")
                
            case .moreOlderThanYounger:
                print("The city's population skews older compared to younger residents. This demographic trend suggests the need for policies and investments in healthcare, eldercare, and pension systems to support the aging population.")
        }
    }
                                
}



let bratislavaCity: City = City(numberOfCitizens: 10000, numberOfCars: 1050, numberOfFamilies: 10000, cityName: "Bratislava")

bratislavaCity.QualityOfLifeBasedOnCars(numberOfCars: 15234)

bratislavaCity.BasedOnFamilies(famieliesInCity: .moreOlderNoYounger)




struct PayAsYouRide {
    
    enum Salary {
        case junior, medior, senior
    }
    
    static func payByKmAndSalary (salaryNumber: Salary, payPerKilometer: Double, kilometersYouDone: Int) -> Double {

        let result: Double

        switch salaryNumber {
            
        case .junior:
            result = 1.38 * Double(payPerKilometer + Double(kilometersYouDone))
            
        case .medior:
            result = 1.68 * Double(payPerKilometer + Double(kilometersYouDone))
            
        case .senior:
            result = 2.12 * Double(payPerKilometer + Double(kilometersYouDone))
        }
        print(result)
        return result
        
    }
}




var myRide = PayAsYouRide.payByKmAndSalary(salaryNumber: .medior, payPerKilometer: 0.15, kilometersYouDone: 15)



class PayAsYouRide2 {
    
    enum Salary {
        case junior, medior, senior
    }
    
    static func payByKmAndSalary (salaryNumber: Salary, payPerKilometer: Double, kilometersYouDone: Int) -> Double {

        let result: Double

        switch salaryNumber {
            
        case .junior:
            result = 1.38 * Double(payPerKilometer + Double(kilometersYouDone))
            
        case .medior:
            result = 1.68 * Double(payPerKilometer + Double(kilometersYouDone))
            
        case .senior:
            result = 2.12 * Double(payPerKilometer + Double(kilometersYouDone))
        }
        print(result)
        return result
        
    }
}




var myRide2 = PayAsYouRide2.payByKmAndSalary(salaryNumber: .senior, payPerKilometer: 1.5, kilometersYouDone: 14)




