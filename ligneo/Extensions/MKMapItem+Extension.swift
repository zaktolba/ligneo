//
//  MKMapItem+Extension.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import Foundation
import MapKit
import CryptoKit

extension MKMapItem {
    var id: String {
        let coordinates = String(describing: placemark.coordinate)
        let sha = SHA256.hash(string: coordinates)
        return sha
    }
}

struct MapItemID: Hashable {
    var uniqueID: String
}

/// Errors resulting from `MapKit` functions.
enum MapDataError: LocalizedError {
    case sceneRequestError(String, String?, Error)
    
    var errorDescription: String? {
        switch self {
        case .sceneRequestError(let locationID, let locationName, let error):
            let location = locationName ?? "<Unknown Location Name>"
            return String(localized: "Look Around scene request failed for itemID \(locationID) (\(location): \(error.localizedDescription)")
        }
    }
}
