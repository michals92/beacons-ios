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
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    private let apiService: ApiService = RestApiService()
    private let locationManager = CLLocationManager()

    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        bind()
    }

    deinit {
        subscribers.forEach { $0.cancel() }
    }

    private func bind() {
        $location
            .map { MKCoordinateRegion(center: $0?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 0.05, longitudinalMeters: 0.05) }
            .assign(to: &$region)
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
