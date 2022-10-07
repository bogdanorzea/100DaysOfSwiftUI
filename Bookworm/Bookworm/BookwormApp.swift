//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Bogdan Orzea on 2022-10-04.
//

import SwiftUI

@main
struct BookwormApp: App {
    @ObservedObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
