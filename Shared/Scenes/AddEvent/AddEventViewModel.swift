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

    @Published var name: String
    @Published var desc: String
    @Published var duration: Int
    /*let latitude: Float
    let longitude: Float*/

    private let apiService: ApiService = RestApiService()

    override init() {
        name = ""
        desc = ""
        duration = 30

        super.init()
    }

    deinit {
        subscribers.forEach { $0.cancel() }
    }

    func addPoint() {
        guard !name.isEmpty && !desc.isEmpty else {
            print("something is missing!")
            return
        }

        subscribers.append(
            apiService.addBeacon(name: name, description: desc, latitude: 0, longitude: 0, duration: Float(duration), date: Date().ISO8601Format()).sink(receiveCompletion: { completion in
                //Subscribers.Completion<ApiError>
                print(completion)
            }, receiveValue: { beacon in
                print(beacon.name)
            })
        )
        //TODO: - show if point was successfully added in alert
    }
}
