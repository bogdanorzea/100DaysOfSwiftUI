//
//  AcquaintanceDetails.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-01-29.
//

import MapKit
import SwiftUI

struct AcquaintanceDetails: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: ViewModel
    var onSave: (Acquaintance) -> Void
    
    @State private var region: MKCoordinateRegion
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    init(acquaintance: Acquaintance, onSave: @escaping (Acquaintance) -> Void) {
        self.viewModel = ViewModel(acquaintance: acquaintance)
        self.onSave = onSave
        
        self._region = State(
            initialValue: MKCoordinateRegion(
                center: acquaintance.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $viewModel.pickerSelection) {
                ForEach(ViewModel.ViewSelection.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.segmented)
            .fixedSize()
            .padding(.horizontal)
            
            ZStack {
                List {
                    Section() {
                        Group {
                            if let uiImage = UIImage(contentsOfFile: viewModel.acquaintance.imageUrl.path()) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
                        TextField("First name", text: $viewModel.acquaintance.firstName)
                        TextField("Last name", text: $viewModel.acquaintance.lastName)
                        TextField("Company", text: $viewModel.acquaintance.companyName)
                    }
                    
                    Section("Contact") {
                        TextField("E-mail", text: $viewModel.acquaintance.email)
                            .keyboardType(.emailAddress)
                        
                        TextField("Phone number", text: $viewModel.acquaintance.phone)
                            .keyboardType(.phonePad)
                    }
                    
                    Section("Notes") {
                        TextField("Notes", text: $viewModel.acquaintance.notes, axis: .vertical)
                            .lineLimit(3...)
                    }
                }
                .opacity(viewModel.detailsOpacity)
                
                ZStack {
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: viewModel.annotationItems) { acquaintance in
                        MapMarker(coordinate: acquaintance.coordinate, tint: Color.purple)
                    }
                    .ignoresSafeArea()
                    
                    Image(systemName: "target")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 44)
                        .foregroundColor(.red)
                }
                .opacity(viewModel.mapOpacity)
            }
            .navigationTitle(viewModel.acquaintance.fullName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    viewModel.saveCoordinates(region.center)
                    onSave(viewModel.acquaintance)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct AcquaintanceDetails_Previews: PreviewProvider {
    static var previews: some View {
        AcquaintanceDetails(acquaintance: Acquaintance.example) { _ in }
    }
}

extension Acquaintance {
    var coordinate: CLLocationCoordinate2D {
        if let lat, let lon {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            return CLLocationCoordinate2D()
        }
    }
}
