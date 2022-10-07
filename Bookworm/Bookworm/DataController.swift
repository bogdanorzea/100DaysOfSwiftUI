//
//  DataController.swift
//  Bookworm
//
//  Created by Bogdan Orzea on 2022-10-04.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to initialize Core Data: \(error.localizedDescription)")
            }
        }
    }
}
