//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-07.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    var body: some View {
        List {
            ForEach(wizards) { wizard in
                Text(wizard.name ?? "Unknown")
            }
        }
        
        Button("Add") {
            let wizard = Wizard(context: moc)
            wizard.name = "Harry Potter"
        }
        
        Button("Save") {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
