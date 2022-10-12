//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-07.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
//            CountriesView()
            SingerView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
