//
//  Card.swift
//  Flashzilla
//
//  Created by Bogdan Orzea on 2023-04-10.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
