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
        do {
            let squaredImage = self.squareWithPadding(toSize: 513)
            let imageBuffer = self.buffer(from: squaredImage!)
            let model = try DeepLabV3(configuration: .init())
            let prediction = try model
                .prediction(image: imageBuffer!)
                .semanticPredictions
            print(prediction)
            // TODO: Blur image background using the prediction array
            
            return self
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Image utilities
    // TODO: Let the user crop their image to a square
    func squareWithPadding(toSize: Int) -> UIImage? {
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
    
    func resize(toSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: toSize.width,
                             height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
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
        guard (status == kCVReturnSuccess) else {
            return nil
        }
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
