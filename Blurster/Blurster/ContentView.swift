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
            
            // MARK: - Image
            if viewModel.selectedImage != nil {
                Spacer()
                Image(uiImage: viewModel.selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            // MARK: - Buttons
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Button(action: {
                        viewModel.choosePhoto()
                    }, label: {
                        Text("Choose Photo")
                            .sheet(
                                isPresented: $viewModel.isPresentingImagePicker,
                                content: {ImagePicker(
                                    sourceType: viewModel.sourceType,
                                    completionHandler: viewModel.didSelectImage
                                    )})
                    }).buttonStyle(blueButtonStyle())
                }
                Spacer()
                if viewModel.selectedImage != nil {
                    if viewModel.isProcessed {
                        Button(action: {
                            viewModel.saveImage()
                        }, label: {
                            Text("Save Photo")
                        }).buttonStyle(blueButtonStyle())
                    } else {
                        Button(action: {
                            viewModel.processImage()
                        }, label: {
                            Text("Get Blurred!")
                        }).buttonStyle(blueButtonStyle())
                    }
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

struct blueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, idealWidth: 150, maxWidth: 200,
                   minHeight: 0, idealHeight: 40, maxHeight: 50,
                   alignment: .center)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
