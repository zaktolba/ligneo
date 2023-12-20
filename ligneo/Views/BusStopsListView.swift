//
//  BusStopsListView.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import SwiftUI

struct BusStopsListView: View {
    @State var busTimetable: BusTimetable
    @State private var isPresentingNewScrumView = false
    
    var body: some View {
        List {
            ForEach(busTimetable.stops) { stop in
                HStack {
                    NavigationLink(destination: BusStopDetails(busStop: stop)) {
                        Text("\(stop.name)")
                    }
                }
            }
        }
        .navigationTitle("Bus stops")
    }
}
