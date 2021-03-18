//
//  CIImage+Helpers.swift
//  Blurster
//
//  Created by Aleksei Klopov on 06.03.2021.
//

import UIKit
import CoreML

extension CIImage {
    
    func toUIImage() -> UIImage? {
        let context: CIContext = CIContext.init(options: nil)
        guard let cgImage = context.createCGImage(self, from: self.extent)
        else { return nil }
        return UIImage(cgImage: cgImage, scale: 0, orientation: .up)
    }
    
    func blurWith(mask: CIImage, radius: Int) -> CIImage? {
        let blurredCIImage = self
            .clampedToExtent()
            .applyingFilter("CIGaussianBlur",
                            parameters: [kCIInputRadiusKey: radius])
            .cropped(to: self.extent)
        guard let compositeImage = CIFilter(
            name: "CIBlendWithMask",
            parameters: [
                kCIInputImageKey: self,
                kCIInputBackgroundImageKey: blurredCIImage,
                kCIInputMaskImageKey: mask])?.outputImage
        else { return nil }
        return compositeImage
    }
    
    func scale(_ factor: CGFloat) -> CIImage? {
        guard let outputImage = CIFilter(
                name: "CILanczosScaleTransform",
                parameters: [
                    kCIInputImageKey: self,
                    kCIInputScaleKey: factor,
                    kCIInputAspectRatioKey: 1])?.outputImage
        else { return nil }
        return outputImage
    }
    
}
