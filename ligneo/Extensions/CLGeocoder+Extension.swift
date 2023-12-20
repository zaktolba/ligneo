//
//  CLGeocoder+Extension.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import Foundation
import CoreLocation

extension CLGeocoder {
    static func reverseGeocodeLocation(coordinate: CLLocationCoordinate2D) async throws -> CLPlacemark{
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first else {
            throw CLError(.geocodeFoundNoResult)
        }
        
        return placemark
    }
}
