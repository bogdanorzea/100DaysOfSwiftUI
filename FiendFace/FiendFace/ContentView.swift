//
//  ContentView.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import SwiftUI

struct ContentView: View {
    @State var users: [User] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink {
                        UserDetails(user: user)
                    } label: {
                        Text(user.name)
                    }
                }
            }.navigationTitle("FriendFace")
        }.onAppear {
            Task {
                if users.isEmpty {
                    await fetchData()
                }
            }
        }
    }
    
    func fetchData() async {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedData = try decoder.decode([User].self, from: data)
            
            users = decodedData
        } catch {
            print("There was an error fetching data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

