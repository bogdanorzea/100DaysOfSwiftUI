//
//  AddExpense.swift
//  iExpense
//
//  Created by Bogdan Orzea on 2022-06-27.
//

import SwiftUI

struct AddExpense: View {
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency = "USD"
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(ExpenseItem.types, id: \.self) { t in
                        Text(t)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: currency))
                    .keyboardType(.decimalPad)
                
                Picker("Currency", selection: $currency) {
                    ForEach(ExpenseItem.currencies, id: \.self) { t in
                        Text(t)
                    }
                }
            }
                .navigationTitle("Add expense")
                .toolbar {
                    Button("Add") {
                        expenses.items.append(ExpenseItem(name: name, type: type, amount: amount, currency: currency))
                        
                        dismiss()
                    }
                }
        }
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(expenses: Expenses())
    }
}
