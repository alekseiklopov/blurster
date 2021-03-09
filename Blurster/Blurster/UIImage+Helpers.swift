//
//  UIImage+Helpers.swift
//  Blurster
//
//  Created by Aleksei Klopov on 05.03.2021.
//

import UIKit
import CoreML

extension UIImage {
    
    // MARK: - Image predictions
    func getBlurred() -> UIImage? {
        
        // Set a size for making predictions using the ML model
        let n = 513
        
        // Define helpers
        
        // Create an n-by-n mask
        func createMask(array: MLMultiArray) -> CIImage? {
            var imageArray: [UInt8] = []
            for i in 0 ..< n * n {
                // Create a mask only for the people in the image
                if array[i] == 15 {
                    imageArray.append(255)
                } else {
                    imageArray.append(0)
                }
            }
            let data = Data(imageArray)
            let newImage = CIImage(
                bitmapData: data,
                bytesPerRow: n,
                size: CGSize(width: n, height: n),
                format: CIFormat(rawValue: CIFormat
                                    .RawValue(kCVPixelFormatType_1Monochrome)),
                colorSpace: nil)
            return newImage
        }
        
        do {
            // Prepare the image for ML model
            guard let squaredImage = self.squareWithPadding(toSize: n),
                  let imageBuffer = self.buffer(from: squaredImage)
            else { return nil }
            
            // Predict results
            let model = try DeepLabV3(configuration: .init())
            let prediction = try model
                .prediction(image: imageBuffer)
                .semanticPredictions
            
            // Create, crop and resize the mask to initial image size
            let w = self.size.width, h = self.size.height
            var squaredImageHeight = Int(CGFloat(n) * h / w)
            var squaredImageWidth = n
            var sizeCoefficient = w / CGFloat(n)
            if h > w {
                squaredImageHeight = n
                squaredImageWidth = Int(CGFloat(n) * w / h)
                sizeCoefficient = h / CGFloat(n)
            }
            guard let maskCIImage = createMask(array: prediction)?
                    .cropped(to: CGRect(x: 0,
                                        y: 0,
                                        width: squaredImageWidth,
                                        height: squaredImageHeight))
                    .scale(sizeCoefficient)
            else { return nil }
            
            // Blur image background
            guard let ciImage = CIImage(image: self),
                  let outputImage = ciImage
                    .blurWith(mask: maskCIImage)?
                    .toUIImage()
            else { return nil }
            
            return outputImage
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Image utilities
    // TODO: Let the user crop their image to a square
    private func squareWithPadding(toSize: Int) -> UIImage? {
        // First place the image into a square of maximum size of the image,
        // then resize it to new size.
        // It's necessary to process an unscaled image.
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
    
    private func resize(toSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: toSize.width,
                             height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(image.size.width),
            Int(image.size.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer)
        guard (status == kCVReturnSuccess) else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer!,
                                     CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: pixelData, width: Int(image.size.width),
            height: Int(image.size.height), bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0,
                              y: 0,
                              width: image.size.width,
                              height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!,
                                       CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
    
}
