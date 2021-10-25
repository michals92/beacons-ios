//
//  MapViewModel.swift
//  Beacon
//
//  Created by Michal Šimík on 22.10.2021.
//

import Foundation
import Combine
import MapKit

class MapViewModel: NSObject, Identifiable, ObservableObject {
    var subscribers: [AnyCancellable] = []

    @Published var beacons: [Beacon]?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    private let apiService: ApiService = RestApiService()
    private let locationManager = CLLocationManager()

    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()

        locationManager.delegate = self

        locationManager.startUpdatingLocation()
        if let location = locationManager.location {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }

    deinit {
        subscribers.forEach { $0.cancel() }
    }

    func getBeacons() {
        subscribers.append(
            apiService
                .getBeacons()
                .replaceError(with: nil).sink { beacons in
                    DispatchQueue.main.async {
                        self.beacons = beacons
                    }
                }
        )
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = locationManager.authorizationStatus
    }
}
