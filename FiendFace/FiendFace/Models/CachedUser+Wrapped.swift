//
//  CachedUser+Wrapped.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-15.
//

import Foundation

extension CachedUser {
    var wrappedName: String { name ?? "Unknown" }
    var wrappedCompany: String { company ?? "Unknown" }
    var wrappedEmail: String { email ?? "Unknown" }
    var wrappedAddress: String { address ?? "Unknown" }
    var wrappedAbout: String { about ?? "Unknown" }
    var wrappedTags: String { tags ?? "Unknown" }
    var wrappedRegistered: Date { registered ?? Date() }
    
    public var friendsArray: [CachedFriend] {
        let set = friends as? Set<CachedFriend> ?? []
        
        return set.sorted { $0.wrappedName < $1.wrappedName }
    }
}
