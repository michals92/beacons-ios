//
//  ApiService.swift
//  Beacon (iOS)
//
//  Created by Michal Šimík on 20.10.2021.
//

import Foundation
import Combine
import UIKit

enum ApiError: Error {
    case emptyData
}

protocol ApiService {
    func addBeacon(name: String, description: String, latitude: Float, longitude: Float, duration: Float, date: String) -> AnyPublisher<Beacon, Error>
    func getBeacons() -> AnyPublisher<[Beacon], Error>
    func getBeacons2()
}

class RestApiService: ObservableObject, ApiService {
    var cancellables = Set<AnyCancellable>()

    let apiUrl = URL(string: "https://immense-cliffs-07774.herokuapp.com/")

    public init() {}

    func addBeacon(name: String, description: String, latitude: Float, longitude: Float, duration: Float, date: String) -> AnyPublisher<Beacon, Error> {
        let path = "addBeacon"
        guard let url = URL(string: path, relativeTo: apiUrl) else {
            fatalError("bad url")
        }

        let params: [String: Any] = [
            "name": name,
            "description": description,
            "latitude": latitude,
            "longitude": longitude,
            "duration": duration,
            "date": date
        ]

        var request =  URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])

        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Beacon.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func getBeacons() -> AnyPublisher<[Beacon], Error> {
        let path = "beacons"
        guard let url = URL(string: path, relativeTo: apiUrl) else {
            fatalError("bad url")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Beacon].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func getBeacons2() {
        let path = "beacons"
        guard let url = URL(string: path, relativeTo: apiUrl) else {
            fatalError("bad url")
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Beacon].self, decoder: JSONDecoder()).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("Received completion: \($0).") },
                  receiveValue: { beacons in
                print("Received user: \(beacons).")})
    }
}

