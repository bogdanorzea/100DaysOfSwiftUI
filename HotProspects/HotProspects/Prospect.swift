//
//  Prospect.swift
//  HotProspects
//
//  Created by Bogdan Orzea on 2023-02-06.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var email = ""
    fileprivate(set) var contactedAt: Date?
}

extension Prospect {
    var isContacted: Bool { contactedAt != nil }
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    private let saveKey = "SavedData"
    
    private static var filename: URL {
        FileManager.getDocumentsDirectory().appendingPathComponent("prospects.json")
    }
    
    init() {
        self.people = FileManager.read(from: Self.filename, default: [])
    }
    
    private func save() {
        FileManager.save(data: people, to: Self.filename)
    }
    
    func add(prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(prospect: Prospect) {
        objectWillChange.send()
        prospect.contactedAt = Date()
        save()
    }
}
