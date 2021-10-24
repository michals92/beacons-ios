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
                    TextField("Jméno", text: $viewModel.name)
                    TextField("Popis", text: $viewModel.desc)

                    Picker(selection: $viewModel.duration, label: Text("Trvání")) {
                        Text("30").tag(1)
                        Text("60").tag(2)
                        Text("90").tag(3)
                    }
                }

                Section {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Potvrdit")
                    }
                }
            }.navigationTitle("Přidat bod")
        }
    }
}

struct AddEvent_Previews: PreviewProvider {
    static var previews: some View {
        AddEvent()
    }
}
