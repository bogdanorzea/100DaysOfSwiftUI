//
//  Models.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-19.
//

import Foundation

struct Reponse: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
