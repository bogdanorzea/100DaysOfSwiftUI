//
//  FiendFaceApp.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import SwiftUI

@main
struct FiendFaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
