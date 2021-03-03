//
//  ImageUtils.swift
//  Blurster
//
//  Created by Aleksei Klopov on 03.03.2021.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    let sourceType: UIImagePickerController.SourceType
    let completionHandler: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.sourceType = sourceType
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate {
        
        let completionHandler: (UIImage?) -> Void
        
        init(completionHandler: @escaping (UIImage?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info:
                                    [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                completionHandler(selectedImage)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completionHandler(nil)
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
}
