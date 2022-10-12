//
//  SingerView.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-10.
//

import CoreData
import SwiftUI

struct SingerView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter: String = "A"
    
    var body: some View {
        VStack {
            FilteredList(
                filterKey: "lastName",
                filterOperation: .contains,
                filterValue: lastNameFilter,
                sortDescriptors: [SortDescriptor(\Singer.lastName)]
            ) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add") {
                let singer1 = Singer(context: moc)
                singer1.firstName = "Taylor"
                singer1.lastName = "Swift"
                
                let singer2 = Singer(context: moc)
                singer2.firstName = "Ed"
                singer2.lastName = "Sheeran"
                
                let singer3 = Singer(context: moc)
                singer3.firstName = "Adele"
                singer3.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct SingerView_Previews: PreviewProvider {
    static var previews: some View {
        SingerView()
    }
}
