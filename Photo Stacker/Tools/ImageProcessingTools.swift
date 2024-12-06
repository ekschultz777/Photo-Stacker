//
//  ImageProcessingTools.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 7/10/22.
//

import Foundation
import AppKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageProcessingTools {
    //Tools used in the "Tools" section of the app for the final image
    func noiseReduction(inputImage: CIImage, reductionAmount: Float) -> CIImage? {
        let noiseReductionFilter = CIFilter.noiseReduction()
        noiseReductionFilter.inputImage = inputImage
        noiseReductionFilter.noiseLevel = reductionAmount
        return noiseReductionFilter.outputImage
    }
    
    func sharpnessAdjust(inputImage: CIImage, sharpnessValue: Float) -> CIImage? {
        let noiseReductionFilter = CIFilter.noiseReduction()
        noiseReductionFilter.inputImage = inputImage
        noiseReductionFilter.sharpness = sharpnessValue
        return noiseReductionFilter.outputImage
    }
    
    func exposureAdjust(inputImage: CIImage, exposureAmount: Float) -> CIImage? {
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = inputImage
        exposureFilter.ev = exposureAmount
        return exposureFilter.outputImage
    }
    
    func gammaAdjust(inputImage: CIImage, gammaLevel: Float) -> CIImage? {
        let gammaFilter = CIFilter.gammaAdjust()
        gammaFilter.inputImage = inputImage
        gammaFilter.power = 1 / gammaLevel
        return gammaFilter.outputImage
    }
    
    func toNSImage(ciimage: CIImage) -> NSImage { //converts CIImage to NSImage
        let nsImageRepresentation = NSCIImageRep(ciImage: ciimage)
        let nsImage = NSImage(size: nsImageRepresentation.size)
        nsImage.addRepresentation(nsImageRepresentation)
        return nsImage
    }
    
    func toCIImage(nsimage: NSImage) -> CIImage { //converts NSImage to CIImage
        let imageData = (nsimage.tiffRepresentation)!
        let ciimage = CIImage(bitmapImageRep: NSBitmapImageRep(data: imageData)!)
        return ciimage!
    }
    
    func toJPEG(nsimage: NSImage) -> Data {
            let cgImage = nsimage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            let jpegImage = NSBitmapImageRep(cgImage: cgImage).representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
            return jpegImage
    }
}
