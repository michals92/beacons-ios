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

    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                .onAppear {
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
                        print(beacons)
                    })
                }
            Button(action: {
                        self.locationManager.requestAlwaysAuthorization()
                        self.locationManager.requestWhenInUseAuthorization()
                    }) {
                        Text("Request authorization")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
