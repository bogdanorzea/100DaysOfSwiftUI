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

    @State private var pickedImage: UIImage?
    @State private var newAcquaintance: Acquaintance? = nil
    @State private var showActionSheet: Bool = false
    @State private var showNewScreen: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showImagePicker: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.acquaintances.values.sorted()) { acquaintance in
                    NavigationLink {
                        AcquaintanceDetails(acquaintance: acquaintance) { acquaintance in
                            viewModel.addAcquaintance(acquaintance)
                        }
                    } label: {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    showActionSheet = true
                } label: {
                    Text("Add New")
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Picture source"),
                        buttons: [
                            .default(Text("Camera")) { self.showCameraPicker.toggle() },
                            .default(Text("Photo Library")) { self.showImagePicker.toggle() },
                            .destructive(Text("Cancel"))
                        ]
                    )
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $pickedImage)
                }
                .fullScreenCover(isPresented: $showCameraPicker) {
                    CameraPicker(image: $pickedImage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black)
                }
                .sheet(isPresented: $showNewScreen) {
                    AcquaintanceDetails(acquaintance: newAcquaintance!, addLocation: true) {
                        viewModel.addAcquaintance($0)
                    }
                }
            }
        }
        .onChange(of: pickedImage) { pickedImage in
            if let jpegData = pickedImage?.jpegData(compressionQuality: 0.8) {
                let newAcquaintance = Acquaintance()
                let photoUrl = FileManager.documentsDirectory.appending(path: newAcquaintance.id.uuidString)

                do {
                    try jpegData.write(to: photoUrl, options: [.atomic, .completeFileProtection])
                } catch {
                    print(error.localizedDescription)
                    return
                }

                self.newAcquaintance = newAcquaintance
            }
        }
        .onChange(of: newAcquaintance) { newValue in
            self.showNewScreen = newValue != nil
        }
    }
}

struct Acquaintances_Previews: PreviewProvider {
    static var previews: some View {
        Acquaintances()
    }
}
