// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-4

enum Errors : Error {
    case outOfBounds
    case noRoot
}

func squareRoot(_ num: Int) throws -> Int {
    guard num > 1 && num < 10_000 else {
        throw Errors.outOfBounds
    }
    
    
    for i in 1...num {
        let curr = i*i
        
        if curr == num {
            return i
        } else if curr > num {
            break
        }
    }
    
    throw Errors.noRoot
}

do {
    let root = try squareRoot(2500)
    print("\(root)")
} catch {
    print(error)
}
