//
//  ContentView.swift
//  Shared
//
//  Created by Michal Šimík on 20.10.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.blue
        UITabBar.appearance().backgroundColor = .white
    }

    var body: some View {
        TabView {
            MapView().tabItem { Text("Mapa") }.tag(1).edgesIgnoringSafeArea([.top])
            AddEvent().tabItem { Text("Přidat") }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
