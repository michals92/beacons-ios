//
//  AddEventViewModel.swift
//  Beacon
//
//  Created by Michal Šimík on 24.10.2021.
//

import Foundation
import Combine

class AddEventViewModel: NSObject, Identifiable, ObservableObject {
    var subscribers: [AnyCancellable] = []

    @Published var name: String = ""
    @Published var desc: String
    @Published var duration: Float

    /*let latitude: Float
    let longitude: Float
    let date: String*/

    override init() {
        desc = ""
        duration = 30

        super.init()
    }
}
