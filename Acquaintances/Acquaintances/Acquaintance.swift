//
//  Acquaintance.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-01-29.
//

import Foundation

struct Acquaintance: Identifiable, Codable, Comparable {
    private(set) var id = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var companyName: String
    var notes: String
    var lon: Double?
    var lat: Double?
    
    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", email: String = "", phone: String = "", companyName: String = "", notes: String = "", photoName: String? = nil, lat: Double? = nil, lon: Double? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.companyName = companyName
        self.notes = notes
        self.lat = lat
        self.lon = lon
    }
    
    var fullName: String { "\(firstName) \(lastName)" }
    var imageUrl: URL { FileManager.documentsDirectory.appending(path: self.id.uuidString) }
    
    static var example: Acquaintance {
        return Acquaintance(
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@apple.com",
            phone: "+14372312319",
            companyName: "Apple Inc.",
            notes: "He is a really cool person!",
            lat: 0.0,
            lon: 0.0
        )
    }
    
    static func <(lhs:Acquaintance, rhs: Acquaintance) -> Bool { lhs.firstName < rhs.firstName }
}
