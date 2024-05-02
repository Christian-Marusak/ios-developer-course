import UIKit

func addFunction(num1: Int, num2: Int) -> Int {
    let result: Int?
    result = num1 + num2
    
    return result ?? 0
}
let finalResult = addFunction(num1: 1, num2: 2)
print(finalResult)

let addClosure: ((Int, Int) -> (Int)) = {number1, number2 in
    let result = number1 + number2
    
    return result
}

var finalResult1 = addClosure(1, 2)

print(finalResult)


private func nonEscapingClosure(results:(String) -> Void ) {
    print("Closure starts")
    results("Closure called")
    print("Closure ended")
}

nonEscapingClosure(results: {string in
    print("Hello")
})

print("Next clsure")

private func escapignClosure(results: @escaping(String) -> Void ) {
    print(" esc Closure starts")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
        results("esc Closure called")
     
    }
    print(" esc Closure ended")
}

escapignClosure(results: {string in
print(" esc Hello")
})

print(" esc Next closure")
