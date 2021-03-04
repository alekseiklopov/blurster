//
//  UIImage+Segmentation.swift
//  Blurster
//
//  Created by Aleksei Klopov on 05.03.2021.
//

import UIKit

extension UIImage {
    
    func getBlurred() -> UIImage? {
        let squaredImage = self.square(toSize: 513)
        // Then make a prediction and return blurred image
        
        return squaredImage
    }
    
}

extension UIImage {
    
    func resize(toSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0,
                              width: toSize.width, height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func square(toSize: Int) -> UIImage? {
        // First place the image into a square of maximum size of the image,
        // then resize it to new size
        let w = self.size.width, h = self.size.height
        let max_size = max(w, h)
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: max_size, height: max_size), false, 0
        )
        self.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage?.resize(toSize: CGSize(width: toSize, height: toSize))
    }
    
}
