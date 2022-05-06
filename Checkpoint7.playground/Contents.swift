// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-7

class Animal {
    let legs: Int
    
    init(legs: Int) {
        self.legs = legs
    }
}

class Dog: Animal {
    init() {
        super.init(legs: 4)
    }
    
    func speak() {
        print("Woof!")
    }
}

class Cat: Animal {
    let isTame: Bool
    init(isTame: Bool) {
        self.isTame = isTame
        super.init(legs: 4)
    }
    
    func speak() {
        print("Mau")
    }
}

class Corgi: Dog {
    override func speak() {
        print("Royal woof!")
    }
}

class Poodle: Dog {
    override func speak() {
        print("HAM!")
    }
}

class Persian: Cat {
    init() {
        super.init(isTame: true)
    }
}

class Lion: Cat {
    init() {
        super.init(isTame: false)
    }
    
    override func speak() {
        print("ROAR!")
    }
}


var corgi = Corgi()
print(corgi.legs)
corgi.speak()

var lion = Lion()
print(lion.isTame)
lion.speak()
