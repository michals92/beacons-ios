//
//  Beacon.swift
//  Beacon (iOS)
//
//  Created by Michal Šimík on 20.10.2021.
//

import Foundation

struct Beacon: Codable {
    let id: Int
    let name: String
    let description: String
    let latitude: Float
    let longitude: Float
    let duration: Float
    let date: String
}
