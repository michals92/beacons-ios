//
//  AddEventViewModel.swift
//  Beacon
//
//  Created by Michal Šimík on 24.10.2021.
//

import Foundation
import Combine
import CoreLocation
import UIKit

class AddEventViewModel: NSObject, Identifiable, ObservableObject {
    var subscribers: [AnyCancellable] = []

    @Published var name: String
    @Published var desc: String
    @Published var duration: Int

    @Published var myBeacons: [Beacon] = []

    @Published var showingAlert = false
    @Published var alertText = ""

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

    private func cleanForm() {
        name = ""
        desc = ""
        duration = 30
    }

    func addPoint() {
        guard !name.isEmpty && !desc.isEmpty else {
            self.alertText = "Something is missing"
            self.showingAlert = true
            return
        }

        guard let location = CLLocationManager().location else {
            self.alertText = "No location available"
            self.showingAlert = true
            return
        }

        subscribers.append(
            apiService.addBeacon(
                name: name,
                description: desc,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                duration: Double(duration), date: Date().ISO8601Format()
            )
            .sink(receiveCompletion: { completion in

                UIApplication.shared.endEditing()

                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.alertText = error.localizedDescription
                        self.showingAlert = true
                    }
                case .finished:
                    DispatchQueue.main.async {
                        self.alertText = "New beacon added!"
                        self.showingAlert = true
                        self.cleanForm()
                    }
                }

            }, receiveValue: { beacon in
                DispatchQueue.main.async {
                    self.myBeacons.append(beacon)
                }
            })
        )
    }
}

extension UIApplication {
    func endEditing() {
        DispatchQueue.main.async {
            self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
