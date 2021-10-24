//
//  AddEventView.swift
//  Beacon
//
//  Created by Michal Šimík on 24.10.2021.
//

import SwiftUI

struct AddEvent: View {
    @StateObject private var viewModel = AddEventViewModel()

    var body: some View {
        NavigationView {
            List {
                Section("informace") {
                    TextField("Název", text: $viewModel.name)
                    TextField("Popis", text: $viewModel.desc)

                    Picker(selection: $viewModel.duration, label: Text("Trvání")) {
                        Text("30").tag(30)
                        Text("60").tag(60)
                        Text("90").tag(90).navigationTitle("Délka v minutách")
                    }
                }

                Section {
                    Button(action: viewModel.addPoint) {
                        Text("Potvrdit")
                    }
                }
            }.navigationTitle("Přidat bod")
                .alert(viewModel.alertText, isPresented: $viewModel.showingAlert) {
                            Button("OK", role: .cancel) { }
                        }

        }
    }
}

struct AddEvent_Previews: PreviewProvider {
    static var previews: some View {
        AddEvent()
    }
}
