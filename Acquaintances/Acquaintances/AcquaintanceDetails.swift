//
//  AcquaintanceDetails.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-01-29.
//

import SwiftUI

struct AcquaintanceDetails: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var acquaintance: Acquaintance
    var onSave: (Acquaintance) -> Void
    
    var body: some View {
        List {
            Section() {
                Group {
                    if let uiImage = UIImage(contentsOfFile: acquaintance.imageUrl.path()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.badge.questionmark.fill")
                            .resizable(resizingMode: .stretch)
                            .scaledToFit()
                    }
                }
                .frame(width: 176, height: 176)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            
            Section("Details") {
                TextField("First name", text: $acquaintance.firstName)
                TextField("Last name", text: $acquaintance.lastName)
                TextField("Company", text: $acquaintance.companyName)
            }
            
            Section("Contact") {
                TextField("E-mail", text: $acquaintance.email)
                    .keyboardType(.emailAddress)
                
                TextField("Phone number", text: $acquaintance.phone)
                    .keyboardType(.phonePad)
            }
            
            Section("Notes") {
                TextField("Notes", text: $acquaintance.notes, axis: .vertical)
                    .lineLimit(3...)
            }
        }
        .navigationTitle(acquaintance.fullName)
        .toolbar {
            Button("Save") {
                onSave(acquaintance)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AcquaintanceDetails_Previews: PreviewProvider {
    static var previews: some View {
        AcquaintanceDetails(acquaintance: Acquaintance.example) { _ in }
    }
}

