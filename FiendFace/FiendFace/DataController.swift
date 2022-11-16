//
//  DataController.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-15.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Cache")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
