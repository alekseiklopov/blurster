//
//  ContentView.swift
//  blurster
//
//  Created by Aleksei Klopov on 27.02.2021.
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
                        print("Processing image...")
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

extension ContentView {
    final class ViewModel: ObservableObject {
        
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        
        private(set) var sourceType: UIImagePickerController.SourceType =
            .camera
        
        func choosePhoto() {
            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }
        
        func takePhoto() {
            sourceType = .camera
            isPresentingImagePicker = true
        }
        
        func didSelectImage(_ image: UIImage?) {
            selectedImage = image
            isPresentingImagePicker = false
        }
        
    }
}
