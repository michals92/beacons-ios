//
//  ContentView.swift
//  Shared
//
//  Created by Michal Šimík on 20.10.2021.
//

import SwiftUI
import Combine

//var publisher: AnyPublisher<[Beacon], Error>?
var subscriber: Cancellable?

struct ContentView: View {
    let apiService: ApiService = RestApiService()

    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                subscriber = apiService.getBeacons().sink(receiveCompletion: { completion in
                    print(completion)

                    switch completion {
                    case .failure(let error):
                        print(error)
                        break
                        //TODO :- add error reaction
                    case .finished: break
                        //TODO : - finished successfully
                    }
                }, receiveValue: { beacons in
                    print(beacons)
                })
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
