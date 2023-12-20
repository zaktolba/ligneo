//
//  File.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 17/12/2023.
//

import SwiftUI

@MainActor
class BusTimetableStore: ObservableObject {
    @Published var busTimetables: [BusTimetable] = []

    func load() async throws {
        let filenames = ["bus_timetable_113_venissieux_givors", "bus_timetable_113_givors_venissieux"]

        var loadedTimetables = [BusTimetable]()
        
        for filename in filenames {
            do {
                let fileURL = try self.fileURL(for: filename)
                let data = try Data(contentsOf: fileURL)
                let busTimetable = try JSONDecoder().decode(BusTimetable.self, from: data)
                loadedTimetables.append(busTimetable)
            } catch {
                print("Error loading file \(filename): \(error)")
                throw error
            }
        }

        self.busTimetables = loadedTimetables
    }

    private func fileURL(for filename: String) throws -> URL {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "File \(filename) not found."])
        }
        return url
    }
}
