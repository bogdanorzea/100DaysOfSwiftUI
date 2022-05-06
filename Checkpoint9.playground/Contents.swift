// https://www.hackingwithswift.com/quick-start/beginners/checkpoint-9

func randomInt(in range: [Int]? = Array(0...100)) -> Int { range!.randomElement()! }

print(randomInt(in: [1, 3, 4, 5]))
print(randomInt())
