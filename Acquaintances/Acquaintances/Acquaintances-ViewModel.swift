//
//  Acquaintances-ViewModel.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-01-29.
//

import Foundation

extension Acquaintances {
    @MainActor
    class ViewModel: ObservableObject {
        static var fileSaveUri: URL {
            FileManager.documentsDirectory.appending(path: "acquaintances.json")
        }
        
        @Published var acquaintances: [UUID:Acquaintance] {
            didSet {
                saveToDisk()
            }
        }
        
        init() {
            do {
                let jsonAcquaintances = try Data(contentsOf: Self.fileSaveUri)
                self.acquaintances = try JSONDecoder().decode([UUID:Acquaintance].self, from: jsonAcquaintances)
            } catch {
                self.acquaintances = [:]
            }
        }
        
        func addAcquaintance(_ acquaintance: Acquaintance) {
            acquaintances[acquaintance.id] = acquaintance
        }
        
        func saveToDisk() {
            do {
                let jsonAcquaintances = try JSONEncoder().encode(self.acquaintances)
                try jsonAcquaintances.write(to: Self.fileSaveUri, options: [.atomic, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
