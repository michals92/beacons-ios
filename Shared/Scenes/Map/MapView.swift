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
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.beacons ?? [], annotationContent: { beacon in
                                    MapAnnotation(
                                        coordinate: beacon.coordinate,
                                        anchorPoint: CGPoint(x: 0.5, y: 0.7)
                                    ) {
                                        VStack {
                                            Text(beacon.name)
                                            Image(systemName: "mappin.circle.fill")
                                                .font(.title)
                                                .foregroundColor(.red)
                                                .onTapGesture {
                                                    print("tapped")
                                                }
                                        }
                                    }
                                }
            ).onAppear {
                viewModel.getBeacons()
            }
            LocationPermissionView().environmentObject(viewModel)
        }
    }
}

struct LocationPermissionView: View {
    @EnvironmentObject private var viewModel: MapViewModel

    var body: some View {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(viewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            EmptyView()
        default:
            Text("Unexpected status")
        }
    }
}
