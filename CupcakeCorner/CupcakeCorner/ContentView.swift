//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Flavor", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper("Quantity: \(order.quantity)", value: $order.quantity, in: 3...20, step: 1)
                }
                
                Section {
                    Toggle("Special request", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Add sprinkles", isOn: $order.addSprinkles)
                        Toggle("Extra frosting", isOn: $order.extraFrosting)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
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
