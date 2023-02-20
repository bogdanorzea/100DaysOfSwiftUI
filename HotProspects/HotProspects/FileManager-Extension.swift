//
//  FileManager-Extension.swift
//  HotProspects
//
//  Created by Bogdan Orzea on 2023-02-13.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    static func save<T: Encodable>(data: T, to filename: URL) {
        if let encoded = try? JSONEncoder().encode(data) {
            do {
                try encoded.write(to: filename,options: [.atomic, .completeFileProtection])
            } catch {
                print("Error saving to disk: \(error.localizedDescription)")
            }
        }
    }
    
    static func read<T: Decodable>(from filename: URL, default: T) -> T {
        do {
            let data = try Data(contentsOf: filename)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            
            return decoded
        } catch {
            print("Error reading from disk: \(error.localizedDescription)")
            
            return `default`
        }
    }
}
