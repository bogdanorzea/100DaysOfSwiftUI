//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Bogdan Orzea on 2023-01-23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
