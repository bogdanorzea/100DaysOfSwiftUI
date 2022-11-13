//
//  UserDetails.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import SwiftUI
import MapKit
import CoreLocation

struct UserDetails: View {
    @Environment(\.openURL) var openURL
    
    var user: User
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            UserAvatar(name: user.name, isActive: user.isActive)
            
            Text("Member since \(user.registered, formatter: Self.taskDateFormat)")
                .font(.caption2)
                .padding(.bottom)

            UserDetailsSection(label: "Company") {
                Text(user.company)
                    .font(.headline)
            }
            
            UserDetailsSection(label: "E-mail") {
                Button(user.email) {
                    if let url = URL(string: "mailto:\(user.email)") {
                        openURL(url)
                    }
                }
            }
            
            UserDetailsSection(label: "Address") {
                Button {
                    Self.openAddressInMap(user.address)
                } label: {
                    Text(user.address)
                        .multilineTextAlignment(.leading)
                }
            }
            
            UserDetailsSection(label: "Tags") {
                Text(user.tags.joined(separator: ", "))
            }
            
            UserDetailsSection(label: "About") {
                Text(user.about)
            }
            
            UserDetailsSection(label: "Friends") {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                        .padding(.bottom, 4)
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    static func openAddressInMap(_ address: String?) {
        guard let address = address else {return}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks?.first else {
                return
            }
            
            let location = placemarks.location?.coordinate
            
            if let lat = location?.latitude, let lon = location?.longitude {
                let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
                destination.name = address
                
                MKMapItem.openMaps(
                    with: [destination]
                )
            }
        }
    }
}


struct UserAvatar: View {
    let name: String
    let isActive: Bool
    var acronim: String {
        get {
            name.split(separator: " ").map{ "\($0.first!)" }.joined()
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isActive ? .green : .gray)
                .shadow(radius: 4.0)
                
            
            Text(acronim)
                .foregroundColor(.white)
                .font(.title)
        }
            .frame(width: 64, height: 64)
            .padding()
    }
}

struct UserDetailsSection<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .italic()
                    .padding(.bottom, 2.0)
                
                content
                    .padding(.leading)
            }
            
            Spacer()
        }
        .padding(.bottom)
    }
}


struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        let fakeUser = User(
            id: UUID(),
            isActive: true,
            age: 32,
            company: "Orzea Inc.",
            name: "Bogdan Orzea",
            email: "bogdan@orzea.ca",
            address: "1 University, Toronto, Ontario, Canada",
            about: "Lorem ipsum stuff...",
            tags: ["cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim","tempor"],
            registered: Date(),
            friends: [
                Friend(id: UUID(), name: "Eugenia"),
                Friend(id: UUID(), name: "Sebi"),
                Friend(id: UUID(), name: "Iulia"),
            ]
        )
        
        return UserDetails(user: fakeUser)
    }
}
