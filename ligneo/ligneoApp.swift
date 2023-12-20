//
//  ligneoApp.swift
//  ligneo
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import SwiftUI

@main
struct ligneoApp: App {
    @StateObject private var store = BusTimetableStore()
    
    var body: some Scene {
        WindowGroup {
            BusDirectionsListView(busDirections: $store.busTimetables)
                .task {
                    do {
                        try await store.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
