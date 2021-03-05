//
//  ContentView+ViewModel.swift
//  Blurster
//
//  Created by Aleksei Klopov on 05.03.2021.
//

import SwiftUI

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
        
        func processImage() {
            // FIXME: Check why async doesn't work
            DispatchQueue.main.async {
                self.selectedImage = self.selectedImage?.getBlurred()
            }
        }
        
    }
    
}
