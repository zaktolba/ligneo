//
//  BusStop.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 17/12/2023.
//

import Foundation

// Struct to represent each bus stop and its times
struct BusStop: Codable {
    var name: String
    var town: String
    var times: [String]
    var coords: Coords?
    
    init(id: UUID = UUID(), name: String, town: String, times: [String], coords: Coords) {
        self.name = name
        self.town = town
        self.times = times
        self.coords = coords
    }
}

extension BusStop: Identifiable {
    var id: String { name }
}

struct Coords: Codable {
    var latitude: Double
    var longitude: Double
}
