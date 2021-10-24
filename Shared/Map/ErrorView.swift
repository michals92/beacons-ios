//
//  ErrorView.swift
//  Beacon
//
//  Created by Michal Šimík on 24.10.2021.
//

import SwiftUI

struct ErrorView: View {
    var errorText: String

    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}
