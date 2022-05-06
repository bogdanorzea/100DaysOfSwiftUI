// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-3

for i in 1...100 {
    var result = ""
    
    if i.isMultiple(of: 3) {
        result += "Fizz"
    }
    
    if i.isMultiple(of: 5) {
        result += "Buzz"
    }
    
    if result.isEmpty {
        result = "\(i)"
    }
    
    print(result)
}
