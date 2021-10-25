//
//  Beacon.swift
//  Beacon (iOS)
//
//  Created by Michal Šimík on 20.10.2021.
//

import Foundation
import CoreLocation

struct Beacon: Codable, Identifiable {
    let id: Int
    var name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let duration: Double
    let date: String

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }

    var dateParsed: Date? {
        return ISO8601DateFormatter().date(from: date)
    }
}
