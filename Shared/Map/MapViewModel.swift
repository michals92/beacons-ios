//
//  MapViewModel.swift
//  Beacon
//
//  Created by Michal Šimík on 22.10.2021.
//

import Foundation
import Combine
import MapKit

class MapViewModel: Identifiable, ObservableObject {
    var subscribers: [AnyCancellable] = []

    @Published var beacons: [Beacon]?
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    private let apiService: ApiService = RestApiService()
    private let locationManager = CLLocationManager()

    init() {
        bind()
    }

    deinit {
        subscribers.forEach { $0.cancel() }
    }

    private func bind() {
        $currentLocation.map { MKCoordinateRegion(center: $0, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))}.assign(to: &$region)
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

    func getCurrentLocation() {
        let lat = locationManager.location?.coordinate.latitude ?? 49.195061
        let log = locationManager.location?.coordinate.longitude ?? 16.606836
        //TODO: - show that I am not able to center and add retry

        currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: log)
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func isAuthorized() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
