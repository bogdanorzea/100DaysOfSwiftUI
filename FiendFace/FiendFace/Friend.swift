//
//  Friend.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import Foundation

struct Friend: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: UUID
    var name: String
}
