//
//  Country+WrapperExtension.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-11.
//

import Foundation

extension Country {
    public var wrappedShortName: String { shortName ?? "Unknown" }
    public var wrappedFullName: String { fullName ?? "Unknown" }
    
    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        
        return set.sorted { $0.wrappedName < $1.wrappedName }
    }
}
