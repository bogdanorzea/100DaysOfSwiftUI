//
//  Order.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-20.
//

import SwiftUI

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        return [name, streetAddress, city, zip]
            .map({ $0.trimmingCharacters(in: .whitespaces)})
            .allSatisfy({ !$0.isEmpty })
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
}

class OrderManager: ObservableObject {
    @Published var order: Order
    
    init(order: Order) {
        self.order = order
    }
}
