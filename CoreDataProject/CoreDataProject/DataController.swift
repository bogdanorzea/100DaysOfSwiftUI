//
//  DataController.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-07.
//

import CoreData
import Foundation

class DataController: ObservableObject {
var container = NSPersistentContainer(name: "CoreDataProject")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to load persistent stores: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
}
