//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-20.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var orderManager: OrderManager
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderManager.order.name)
                TextField("Street address", text: $orderManager.order.streetAddress)
                TextField("City", text: $orderManager.order.city)
                TextField("Zip", text: $orderManager.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(orderManager: orderManager)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(!orderManager.order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(orderManager: OrderManager(order: Order()))
    }
}
