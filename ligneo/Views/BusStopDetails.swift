//
//  BusStopDetails.swift
//  CdR Go
//
//  Created by Zakarya TOLBA on 20/12/2023.
//

import SwiftUI
import MapKit

struct BusStopDetails: View {
    @State var busStop: BusStop
    @State private var isPresentingNewScrumView = false
    @State var lookAroundScene: MKLookAroundScene?
    @Environment(\.colorScheme) var colorScheme
    
    var lookAroundScenes = MapDataResults<String, MKLookAroundScene?>()
    let columnsConfig = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        VStack {
            ScrollView {
                if #available(iOS 17.0, *) {
                    LookAroundPreview(initialScene: lookAroundScene)
                        .frame(height: 170)
                        .overlay(alignment: .bottomTrailing) {
                            Text(busStop.name)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.vertical, 25)
                        .task {
                            if let coords = busStop.coords {
                                do {
                                    let scene = try await lookAroundScene(mapItem: getMapItem(for: .init(latitude: coords.latitude, longitude: coords.longitude)) ?? .forCurrentLocation())
                                    await MainActor.run {
                                        self.lookAroundScene = scene
                                    }
                                } catch {
                                    print("Scene fatching error: \(error.localizedDescription)")
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                }
                
                LazyVGrid(columns: columnsConfig, spacing: 10) {
                    ForEach(busStop.times, id: \.self) { time in
                        if let busTime = timeFormatter.date(from: time) {
                            // Extract just the hour and minute components from both current time and bus time
                            let calendar = Calendar.current
                            let busTimeComponents = calendar.dateComponents([.hour, .minute], from: busTime)
                            let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: Date())
                            
                            // Reconstruct the times for comparison
                            let busTimeToday = calendar.date(bySettingHour: busTimeComponents.hour!, minute: busTimeComponents.minute!, second: 0, of: Date())!
                            let currentDateTime = calendar.date(bySettingHour: currentTimeComponents.hour!, minute: currentTimeComponents.minute!, second: 0, of: Date())!
                            
                            Text("\(time)")
                                .padding()
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .opacity(busTimeToday < currentDateTime ? 0.4 : 1)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .navigationTitle("\(busStop.name)")
            //            .background(
            //                LinearGradient(
            //                    stops: [
            //                        .init(color: colorScheme == .light ? .white : .black, location: 0.7),
            //                        .init(color: Color(#colorLiteral(red: 0.8192091584, green: 0.9995033145, blue: 0.7793050408, alpha: 1)), location: 0.1),
            //                        .init(color: Color(#colorLiteral(red: 0.6287948489, green: 0.8593500853, blue: 0.9951502681, alpha: 1)), location: 0.4),
            //                    ],
            //                    startPoint: .bottomTrailing,
            //                    endPoint: .topLeading
            //                ).opacity(0.8)
            //            )
            //
        }
        
    }
    
    private func getMapItem(for coordinate: CLLocationCoordinate2D) async -> MKMapItem? {
        do {
            let placemark = try await CLGeocoder.reverseGeocodeLocation(coordinate: coordinate)
            let mkPlacemark = MKPlacemark(placemark: placemark)
            let mapItem = MKMapItem(placemark: mkPlacemark)
            
            print("Map item retrieved for coordinate: \(String(describing: coordinate))")
            
            return mapItem
        } catch  {
            print("Error while retrieving map item: \(error)")
            
        }
        return nil
    }
    
    private func lookAroundScene(mapItem: MKMapItem) async throws -> MKLookAroundScene? {
        let sceneResult: Result<MKLookAroundScene?, Error>
        
        // If the scene already loaded, get the stored result.
        if let result = await lookAroundScenes.availableResult(for: mapItem.id) {
            sceneResult = result
        }
        
        // Otherwise, start a loading `Task` if necessary, and wait for the result.
        else {
            sceneResult = await lookAroundScenes.result(for: mapItem.id) {
                
                let sceneRequest = MKLookAroundSceneRequest(mapItem: mapItem)
                do {
                    // If fetching the `MKLookAroundScene` returns `nil` without an `Error`,
                    // Look Around is unavailable for that location.
                    return try await sceneRequest.scene
                } catch {
                    throw MapDataError.sceneRequestError(mapItem.id, mapItem.placemark.title, error)
                }
            }
        }
        
        return try sceneResult.get()
    }
}
