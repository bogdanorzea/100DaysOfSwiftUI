//
//  UserDetails.swift
//  FiendFace
//
//  Created by Bogdan Orzea on 2022-11-12.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation

struct UserDetails: View {
    @Environment(\.openURL) var openURL
    
    var user: CachedUser
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            UserAvatar(name: user.wrappedName, isActive: user.isActive)
            
            Text("Member since \(user.wrappedRegistered, formatter: Self.taskDateFormat)")
                .font(.caption2)
                .padding(.bottom)

            UserDetailsSection(label: "Company") {
                Text(user.wrappedCompany)
                    .font(.headline)
            }
            
            UserDetailsSection(label: "E-mail") {
                Button(user.wrappedEmail) {
                    if let url = URL(string: "mailto:\(user.wrappedEmail)") {
                        openURL(url)
                    }
                }
            }
            
            UserDetailsSection(label: "Address") {
                Button {
                    Self.openAddressInMap(user.address)
                } label: {
                    Text(user.wrappedAddress)
                        .multilineTextAlignment(.leading)
                }
            }
            
            UserDetailsSection(label: "Tags") {
                Text(user.wrappedTags)
            }
            
            UserDetailsSection(label: "About") {
                Text(user.wrappedAbout)
            }
            
            UserDetailsSection(label: "Friends") {
                ForEach(user.friendsArray) { friend in
                    Text(friend.wrappedName)
                        .padding(.bottom, 4)
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(user.wrappedName)
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
        let dataController = DataController()
        let context = dataController.container.viewContext
        
        let fakeUser = CachedUser(context: context)
        fakeUser.id = UUID()
        fakeUser.isActive = true
        fakeUser.name = "Bogdan Orzea"
        fakeUser.age = 32
        fakeUser.company = "Orzea Inc."
        fakeUser.email = "bogdan@orzea.ca"
        fakeUser.address = "1 University, Toronto, Ontario, Canada"
        fakeUser.about = "Lorem ipsum stuff..."
        fakeUser.tags = ["cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim","tempor"].joined(separator: ", ")
        fakeUser.registered = Date()
        
        let friend1 = CachedFriend(context: context)
        friend1.id = UUID()
        friend1.name = "Eugenia"
        friend1.addToUser(fakeUser)
        
        try? context.save()
        
        return UserDetails(user: fakeUser).environment(\.managedObjectContext, context)
    }
}
