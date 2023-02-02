//
//  ContentView.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-01-29.
//

import PhotosUI
import SwiftUI

struct Acquaintances: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var newAcquaintance: Acquaintance? = nil
    @State private var showNewScreen: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.acquaintances.values.sorted()) { acquaintance in
                    NavigationLink(destination: {
                        AcquaintanceDetails(acquaintance: acquaintance) { acquaintance in
                            viewModel.addAcquaintance(acquaintance)
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(acquaintance.fullName)
                            
                            if !acquaintance.companyName.isEmpty {
                                Text(acquaintance.companyName)
                                    .font(.subheadline)
                                    .italic()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Acquaintances")
            .navigationDestination(isPresented: $showNewScreen) {
                if let acquaintance = newAcquaintance {
                    AcquaintanceDetails(acquaintance: acquaintance) { viewModel.addAcquaintance($0) }
                } else {
                    EmptyView()
                }
            }
            .toolbar {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Add New")
                    }
            }
        }
        .onChange(of: selectedItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    let newAcquaintance = Acquaintance()
                    let photoUrl = FileManager.documentsDirectory.appending(path: newAcquaintance.id.uuidString)
                    
                    do {
                        try data.write(to: photoUrl, options: [.atomic, .completeFileProtection])
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                    
                    self.newAcquaintance = newAcquaintance
                    viewModel.addAcquaintance(newAcquaintance)
                }
            }
        }
        .onChange(of: newAcquaintance) { newValue in
            self.showNewScreen = newValue != nil
        }
    }
}

struct Acquaitances_Previews: PreviewProvider {
    static var previews: some View {
        Acquaintances()
    }
}

