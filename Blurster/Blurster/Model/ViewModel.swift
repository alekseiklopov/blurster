//
//  ViewModel.swift
//  Blurster
//
//  Created by Aleksei Klopov on 13.03.2021.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var isPresentingImagePicker = false
    @Published var isPresentingSettings = false
    @Published var isProcessed = false
    
    @Published var selectedImage: UIImage?
    @Published var gaussRadius: Double = 5
    
    
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
        isProcessed = false
        isPresentingImagePicker = false
    }
    
    func processImage() {
        // FIXME: Check why async doesn't work
        DispatchQueue.main.async {
            self.selectedImage = self.selectedImage?
                .getBlurred(radius: Int(self.gaussRadius))
            self.isProcessed = true
        }
    }
    
    func saveImage() {
        if self.selectedImage != nil {
            UIImageWriteToSavedPhotosAlbum(self.selectedImage!,
                                           nil, nil, nil)
            self.isProcessed = false
        }
    }
    
    func openSettings() {
        isPresentingSettings.toggle()
    }
    
}
