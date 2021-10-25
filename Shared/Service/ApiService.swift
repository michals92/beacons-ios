//
//  ApiService.swift
//  Beacon (iOS)
//
//  Created by Michal Šimík on 20.10.2021.
//

import Foundation
import Combine

enum ApiError: Error {
    case emptyData
    case parsing(description: String)
}

protocol ApiService {
    func addBeacon(name: String, description: String, latitude: Double, longitude: Double, duration: Double, date: String) -> AnyPublisher<Beacon, ApiError>
    func getBeacons() -> AnyPublisher<[Beacon]?, ApiError>
}

class RestApiService: ObservableObject, ApiService {
    private let apiUrl = URL(string: "https://immense-cliffs-07774.herokuapp.com/")
    private let session = URLSession.shared

    public init() {}

    func addBeacon(name: String, description: String, latitude: Double, longitude: Double, duration: Double, date: String) -> AnyPublisher<Beacon, ApiError> {
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

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        return session.dataTaskPublisher(for: request)
            .tryMap { data, _ in
                try JSONDecoder().decode(Beacon.self, from: data)
            }
            .mapError { .parsing(description: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    func getBeacons() -> AnyPublisher<[Beacon]?, ApiError> {
        let path = "beacons"
        guard let url = URL(string: path, relativeTo: apiUrl) else {
            fatalError("bad url")
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                try JSONDecoder().decode([Beacon].self, from: data)
            }
            .mapError { .parsing(description: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
