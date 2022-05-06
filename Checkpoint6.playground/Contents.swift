// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-6

struct Car {
    let model: String
    let numberOfSeats: Int
    private var currentGear: Int
    
    init(model: String, seats: Int) {
        self.model = model
        self.numberOfSeats = seats
        self.currentGear = 0
    }
    
    mutating func gearUp() {
        currentGear += 1
    }
    
    mutating func gearDown() {
        guard currentGear > 0 else {
            return
        }
        
        currentGear -= 1
    }
}

var car = Car(model: "Ferrari", seats: 2)
car.gearUp()
car.gearUp()
car.gearUp()
car.gearDown()
car.gearDown()
car.gearDown()
car.gearDown()

print(car)
