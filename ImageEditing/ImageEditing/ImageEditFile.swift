//
//  ImageEditFile.swift
//  ImageEditing
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class imageEditing:NSObject{
    
  static  func processImage(image:UIImage)-> UIImage{
        let inPutImage:CIImage = CIImage(cgImage: image as! CGImage)
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: nil)!
        let faces = detector.features(in: inPutImage)
        var mask:CIImage!
        if faces.count>0 {
            var filteredImage:UIImage!
            for face in faces{
                let centerX = face.bounds.origin.x + face.bounds.size.width / 2.0
                let centerY = face.bounds.origin.y + face.bounds.size.height / 2.0
                let radius = min(face.bounds.size.width, face.bounds.size.height) / 1.5
                let radialGradient = CIFilter(name: "CIRadialGradient")
                radialGradient?.setValuesForKeys(["inputRadius0": radius,
                                                  "inputRadius1": radius + 1.0,
                                                  "inputColor0": CIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
                                                  "inputColor1": CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
                                                  kCIInputCenterKey: CIVector(x: centerX, y: centerY)])
                let circle = radialGradient?.outputImage
                if mask != nil {
                    let imageFilter = CIFilter(name: "CIAdditionCompositing")
                    imageFilter?.setValuesForKeys([kCIInputImageKey: circle!, kCIInputBackgroundImageKey:mask])
                    mask = imageFilter?.outputImage
                    
                } else {
                    mask = circle
                }
                let filter = CIFilter(name: "CIPixellate")
                filter?.setValuesForKeys([kCIInputImageKey: inPutImage, "inputScale":10.0])
                let pixelImage = filter?.outputImage
                let outputFilter = CIFilter(name: "CIBlendWithMask")
                outputFilter?.setValuesForKeys([kCIInputImageKey: pixelImage!, kCIInputBackgroundImageKey: inPutImage, kCIInputMaskImageKey: mask])
                
                let outputImage = outputFilter?.outputImage
                let context = CIContext(options: nil)
                let imageRef = context.createCGImage(outputImage!, from: outputImage!.extent)
                filteredImage = UIImage(cgImage: imageRef!)
            }
            return filteredImage
        }else {
            return image
        }
    }
}
