// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-8

protocol Building {
    var rooms : Int { get }
    var cost: Int { get set }
    var agent: String { get set }
    
   
}

extension Building {
    func summary() {
        print("Building has \(rooms) rooms, costs $\(cost) and is listed by \(agent)")
    }
}

struct House: Building {
    var rooms: Int
    var cost: Int
    var agent: String
}

let house = House(rooms: 4, cost: 100_000, agent: "Agent")
house.summary()
