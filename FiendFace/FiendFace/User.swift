//
//  Friend.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import Foundation

struct User: Codable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case id
        case isActive
        case age
        case company
        case name
        case email
        case address
        case about
        case tags
        case registered
        case friends
    }
    
    var id: UUID
    var isActive: Bool
    var age: Int
    var company: String
    var name: String
    var email: String
    var address: String
    var about: String
    var tags: [String]
    var registered: Date
    var friends: [Friend]
}
