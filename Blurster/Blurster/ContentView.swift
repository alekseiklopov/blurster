//
//  ContentView.swift
//  Blurster
//
//  Created by Aleksei Klopov on 03.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            if viewModel.selectedImage != nil {
                Image(uiImage: viewModel.selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            HStack {
                Spacer()
                HStack {
                    Button(action: {
                        viewModel.choosePhoto()
                    }, label: {
                        Text("Choose Photo")
                            .frame(minWidth: 0, idealWidth: 150, maxWidth: 200,
                                   minHeight: 0, idealHeight: 40, maxHeight: 50,
                                   alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(10)
                            .sheet(isPresented:
                                    $viewModel.isPresentingImagePicker,
                                   content: {
                                    ImagePicker(sourceType:
                                                    viewModel.sourceType,
                                                completionHandler:
                                                    viewModel.didSelectImage
                            )})
                    })
                }
                Spacer()
                if viewModel.selectedImage != nil {
                    Button(action: {
                        viewModel.processImage()
                    }, label: {
                        Text("Get blurred")
                            .frame(minWidth: 0, idealWidth: 150, maxWidth: 200,
                                   minHeight: 0, idealHeight: 40, maxHeight: 50,
                                   alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(10)
                    })
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
