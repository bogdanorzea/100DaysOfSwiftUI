//
//  Expenses.swift
//  iExpense
//
//  Created by Bogdan Orzea on 2022-06-27.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encode = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encode, forKey: "Items")
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                
                return
            }
        }
        
        items = []
    }
}

struct ExpenseItem: Codable, Identifiable {
    static var types = ["Personal", "Business"]
    static var currencies = ["USD", "CAD", "EUR", "YEN"]
    
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
}
