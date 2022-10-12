//
//  ShipView.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-10.
//

import SwiftUI

struct ShipView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe IN %@", ["Aliens", "Star Wars"])) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List {
                ForEach(ships, id: \.self) { ship in
                    Text(ship.name ?? "Unknown")
                }
            }
            
            Button("Add") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Millenium Falcon"
                ship2.universe = "Star Wars"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Defiant"
                ship3.universe = "Star Trek"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
        }
    }
}

struct ShipView_Previews: PreviewProvider {
    static var previews: some View {
        ShipView()
    }
}
