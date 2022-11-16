//
//  AppDelegate.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-15.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        return true
    }
}
