//
//  RequestLocationView.swift
//  Beacon
//
//  Created by Michal Šimík on 24.10.2021.
//

import SwiftUI

struct RequestLocationView: View {
    @EnvironmentObject var viewModel: MapViewModel

    var body: some View {
        VStack {
            Button(action: {
                viewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}
