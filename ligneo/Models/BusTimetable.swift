//
//  BusTimetable.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 17/12/2023.
//

import Foundation

// Struct for the entire bus timetable
struct BusTimetable: Codable {
    var origin: String
    var destination: String
    var line: Int
    var servicePeriod: String
    var daysOfOperation: [String]
    var stops: [BusStop]
    
    init(id: UUID = UUID(), origin: String, destination: String, line: Int, servicePeriod: String, daysOfOperation: [String], stops: [BusStop]) {
        self.origin = origin
        self.line = line
        self.destination = destination
        self.servicePeriod = servicePeriod
        self.daysOfOperation = daysOfOperation
        self.stops = stops
    }
}

extension BusTimetable: Identifiable {
    var id: String { destination }
}
