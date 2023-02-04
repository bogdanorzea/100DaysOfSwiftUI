//
//  AcquaintanceDetails-ViewModel.swift
//  Acquaintances
//
//  Created by Bogdan Orzea on 2023-02-03.
//

import CoreLocation
import Foundation

extension AcquaintanceDetails {
    @MainActor class ViewModel: ObservableObject {
        enum ViewSelection: String, CaseIterable {
            case details = "Details"
            case location = "Location"
        }
        
        @Published var pickerSelection =  ViewSelection.details
        @Published var acquaintance: Acquaintance
        
        private let locationFetcher = LocationFetcher()
        
        init(acquaintance: Acquaintance) {
            self.acquaintance = acquaintance
            locationFetcher.start()
        }
        
        var detailsOpacity: Double { pickerSelection == .location ? 0 : 1 }
        var mapOpacity: Double { pickerSelection == .details ? 0 : 1 }
        
        func saveCoordinates(_ coordinates: CLLocationCoordinate2D) {
            acquaintance.lat = coordinates.latitude
            acquaintance.lon = coordinates.longitude
        }
        
        var annotationItems: [Acquaintance] {
            (acquaintance.lat != nil) && (acquaintance.lon != nil)
                ? [acquaintance]
                : []
        }
        
        deinit {
            locationFetcher.stop()
        }
    }
}
