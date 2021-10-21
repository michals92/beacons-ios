//
//  ContentView.swift
//  Shared
//
//  Created by Michal Šimík on 20.10.2021.
//

import SwiftUI
import Combine

//var publisher: AnyPublisher<[Beacon], Error>?

struct ContentView: View {
    var body: some View {
        TabView {
            MapView().tabItem { Text("Map") }.tag(1)
            Text("Add event").tabItem { Text("Add event") }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
