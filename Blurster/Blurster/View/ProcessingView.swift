//
//  ProcessingView.swift
//  Blurster
//
//  Created by Aleksei Klopov on 13.03.2021.
//

import SwiftUI

struct ProcessingView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Image
                if viewModel.selectedImage != nil {
                    Spacer()
                    Image(uiImage: viewModel.selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Spacer()
                    Text("No photos chosen")
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
                            .sheet(isPresented: $viewModel
                                                .isPresentingImagePicker,
                                   content: {
                                    ImageView(sourceType:
                                                viewModel.sourceType,
                                              completionHandler:
                                                viewModel.didSelectImage)})
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
            .navigationBarItems(trailing:
                Button(action: {
                    viewModel.openSettings()
                }, label: {
                    Image(systemName: "slider.horizontal.3").imageScale(.large)
                })
                .sheet(isPresented: $viewModel.isPresentingSettings,
                       content: {
                        SettingsView(viewModel: viewModel)})
            )
        }
    }
}

struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView()
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
