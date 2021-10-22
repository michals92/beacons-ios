//
//  MapView.swift
//  Beacon
//
//  Created by Michal Šimík on 21.10.2021.
//

import SwiftUI
import Combine
import MapKit


struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.beacons ?? [], annotationContent: {
                beacon in
                return MapMarker(
                    coordinate: beacon.coordinate,
                    tint: .red
                )
            }).onAppear {
                viewModel.getCurrentLocation()
                viewModel.getBeacons()
            }

        Button(action: {
            viewModel.requestLocationAuthorization()
        }) {
            Text("Request authorization")
        }.background(.white).hidden()
        }
    }
}
