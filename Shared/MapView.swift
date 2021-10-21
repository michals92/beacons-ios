//
//  MapView.swift
//  Beacon
//
//  Created by Michal Šimík on 21.10.2021.
//

import SwiftUI
import Combine
import MapKit

var subscriber: Cancellable?

struct MapView: View {
    private let locationManager = CLLocationManager()
    let apiService: ApiService = RestApiService()

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var beacons: [Beacon] = []

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: $beacons, annotationContent: {
                beacon in
                return MapMarker(
                    coordinate: beacon.wrappedValue.coordinate,
                    tint: .red
                )
            })
               .onAppear {
                   getCurrentLocation()
                subscriber = apiService.getBeacons().sink(receiveCompletion: { completion in
                    print(completion)

                    switch completion {
                    case .failure(let error):
                        print(error)
                        break
                        //TODO :- add error reaction
                    case .finished: break
                        //TODO : - finished successfully
                    }
                }, receiveValue: { beacons in
                    self.beacons = beacons
                    print(beacons.count)
                })
            }
        }
    }

    func getCurrentLocation() {
        let lat = locationManager.location?.coordinate.latitude ?? 49.195061
        let log = locationManager.location?.coordinate.longitude ?? 16.606836

        print(lat)
        self.region.center = CLLocationCoordinate2D(latitude: lat, longitude: log)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
