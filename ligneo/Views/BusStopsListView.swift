//
//  BusStopsListView.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import SwiftUI
import UIKit

struct BusStopsListView: View {
    @State var busTimetable: BusTimetable
    @State private var isPresentingNewScrumView = false
    
    var body: some View {
        ScrollView {
            ForEach(busTimetable.stops) { stop in
                HStack {
                    NavigationLink(destination: BusStopDetails(busStop: stop)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(stop.name)")
                                    .font(.system(.headline, design: .rounded))
                                Text("\(stop.town)")
                                    .fontWeight(.medium)
                                    .font(.system(.subheadline, design: .monospaced))
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "figure.wave")
                                .opacity(0.6)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                    }.buttonStyle(PlainButtonStyle())
                }
            }.padding([.horizontal, .top], 15)
        }
        .navigationTitle("Bus stops")


    }
}

#Preview {
    BusStopsListView(busTimetable: .init(origin: "", destination: "", line: 113, servicePeriod: "", daysOfOperation: [""], stops: [
        .init(name: "Test", town: "Lyon", times: ["3:00"], coords: .init(latitude: 0, longitude: 0)),
        .init(name: "Test 3", town: "Lyon", times: ["3:00"], coords: .init(latitude: 0, longitude: 0)),
        .init(name: "Test 5", town: "Lyon", times: ["3:00"], coords: .init(latitude: 0, longitude: 0))
    ]))
}
