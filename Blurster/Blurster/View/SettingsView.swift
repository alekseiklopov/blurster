//
//  SettingsView.swift
//  Blurster
//
//  Created by Aleksei Klopov on 12.03.2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gauss Radius"), content: {
                    HStack {
                        Slider(value: $viewModel.gaussRadius, in: 1...10)
                        Text("\(Int(viewModel.gaussRadius))")
                    }
                })
            }
            .navigationBarTitle("Settings")
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark").imageScale(.large)
                }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
