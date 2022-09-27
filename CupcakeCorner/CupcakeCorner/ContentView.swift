//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orderManager = OrderManager(order: Order())
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Flavor", selection: $orderManager.order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper("Quantity: \(orderManager.order.quantity)", value: $orderManager.order.quantity, in: 3...20, step: 1)
                }
                
                Section {
                    Toggle("Special request", isOn: $orderManager.order.specialRequestEnabled.animation())
                    
                    if orderManager.order.specialRequestEnabled {
                        Toggle("Add sprinkles", isOn: $orderManager.order.addSprinkles)
                        Toggle("Extra frosting", isOn: $orderManager.order.extraFrosting)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(orderManager: orderManager)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
