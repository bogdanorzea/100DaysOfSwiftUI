//
//  ContentView.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var cachedUsers: FetchedResults<CachedUser>
        
    var body: some View {
        NavigationView {
            List {
                ForEach(cachedUsers) { user in
                    NavigationLink {
                        UserDetails(user: user)
                    } label: {
                        Text(user.wrappedName)
                    }
                }
            }.navigationTitle("FriendFace")
        }.onAppear {
            Task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedUsers = try decoder.decode([User].self, from: data)
            let _ = decodedUsers.map { save(user: $0) }
            
            await MainActor.run {
                if moc.hasChanges {
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } catch {
            print("There was an error fetching data")
        }
    }
    
    func save(user: User) {
        let cachedUser = CachedUser(context: moc)
        cachedUser.id = user.id
        cachedUser.isActive = user.isActive
        cachedUser.age = Int16(user.age)
        cachedUser.company = user.company
        cachedUser.name = user.name
        cachedUser.email = user.email
        cachedUser.address = user.address
        cachedUser.about = user.about
        cachedUser.tags = user.tags.joined(separator: ",")
        cachedUser.registered = user.registered
        
        let _ = user.friends.map { friend in
            let cachedFriend = CachedFriend(context: moc)
            cachedFriend.id = friend.id
            cachedFriend.name = friend.name
            cachedFriend.addToUser(cachedUser)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

