//
//  BusTimetablesView.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 17/12/2023.
//

import SwiftUI

struct BusDirectionsListView: View {
    @Binding var busDirections: [BusTimetable]
    @State private var isPresentingNewScrumView = false
    let columnsConfig = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columnsConfig, spacing: 10) {
                    ForEach(busDirections) { timetable in
                        NavigationLink(
                            destination: {
                                BusStopsListView(busTimetable: timetable)
                            },
                            label: {
                                Group {
                                    VStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("\(timetable.line)")
                                                    .font(.largeTitle)
                                                    .fontWeight(.heavy)

                                                Spacer()
                                                Image(systemName: "bus.fill")
                                            }
                                            HStack {
                                                Text(" \(timetable.destination)")
                                                    .font(.system(.subheadline, design: .monospaced))
                                                    .fontWeight(.semibold)
                                                    .padding(.leading, -5)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                                .background(.quinary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .navigationTitle("Directions")
                    
                }
                .padding([.horizontal, .top], 15)
                Spacer()
            }
        }
    }
}

#Preview {
    BusDirectionsListView(busDirections: .constant([
        .init(origin: "Vénissieux", destination: "Givors", line: 111, servicePeriod: "", daysOfOperation: [""], stops: [.init(name: "", town: "", times: [""], coords: .init(latitude: 0, longitude: 0))]),
        .init(origin: "Givors", destination: "Vénissieux", line: 111, servicePeriod: "", daysOfOperation: [""], stops: [.init(name: "", town: "", times: [""], coords: .init(latitude: 0, longitude: 0))])
    ]))
}
