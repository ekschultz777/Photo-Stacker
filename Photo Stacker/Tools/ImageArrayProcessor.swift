//
//  ImageProcessor.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 7/6/22.
//

import Foundation
import Vision
import AppKit

class ImageArrayProcessor {
    
    //Arrays to hold images
    var imageBufferArray: [CIImage] = [] //Holds original images
    var alignedImagesBufferArray: [CIImage] = [] //holds images aligned using VNHomographicImageRegistrationRequest
    
    //handler variables for processing and completion
    var completionHandler: ((CIImage) -> Void)? //handles result after images have been aligned
    var isProcessing: Bool = Bool.init() // Boolean which returns true while images are being processed
    
    //Output variables
    var outputImage = CIImage()
    
    private let processingTools = ImageProcessingTools.init()
    
    //Adds an NSImage Array and transforms it to a CIImage array for raw data manipulation
    func addImages(images: Array<NSImage>) {
        for image in images {
            
            let currentCIImage = processingTools.toCIImage(nsimage: image)
            imageBufferArray.append(currentCIImage)
        }
        //print(imageBufferArray) //used for debugging
    }
    
    var imageNum: Int { //returns number of images
        return imageBufferArray.count
    }
    
    func processImagesFromArray(completionHandler: ((CIImage) -> Void)?) {
        isProcessing = true
        self.completionHandler = completionHandler //Sets class completion handler to method completion handler
        //print(imageBufferArray) //used for debugging
        
        let firstImage = imageBufferArray.removeFirst()
        alignedImagesBufferArray.append(firstImage)
        
        for image in imageBufferArray {
            //creates request and performs transform of two images, the second based on the first
            let request = VNTranslationalImageRegistrationRequest(targetedCIImage: image)
            
            do {
                  let sequenceRequestHandler = VNSequenceRequestHandler() //Processes image analysis required for transform of images based on "firstImage"
                  try sequenceRequestHandler.perform([request], on: firstImage)
                }
            catch {
                print("error.localizedDescription: ")
                print(error.localizedDescription)
                }

            //aligns each image in array to first image one at a time
            alignImages(request: request, currentImage: image)
        }
        mergeImages() //merges images after they are aligned
    }
    
    func alignImages(request: VNRequest, currentImage: CIImage) {
        guard
            let results = request.results as? [VNImageTranslationAlignmentObservation],
            let result = results.first
        else {
            return
        }
        
        let alignedImage = currentImage.transformed(by: result.alignmentTransform)

        alignedImagesBufferArray.append(alignedImage)
    }
    
    func mergeImages() {
        
        var outputImage = alignedImagesBufferArray.removeFirst()
        
        let newCIFilter = ImageStackerAverageFilter()
        
        for (i, image) in alignedImagesBufferArray.enumerated() {
            newCIFilter.currentImage = outputImage
            newCIFilter.nextImage = image
            newCIFilter.imageCount = Float(Double(i + 1))
            outputImage = newCIFilter.outputImage()!
        }
        processingComplete(image: outputImage)
        self.outputImage = outputImage
    }
    
    func processingComplete(image: CIImage) { //resets imageArrayProcessor after completion
        imageBufferArray.removeAll()
        alignedImagesBufferArray.removeAll()
        isProcessing = false
        
        if let completionHandler = completionHandler {
            DispatchQueue.main.async {
                completionHandler(image) //calls completionHandler from the main thread
            }
          }
        
        completionHandler = nil
    }
}
