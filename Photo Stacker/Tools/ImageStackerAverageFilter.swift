//
//  ImageStackerAverageFilter.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 7/9/22.
//
//  Creates the CIFilter that will be used to take the average of images

import CoreImage

class ImageStackerAverageFilter: CIFilter {
    
    let kernel: CIColorKernel //GPU based image blender
    var currentImage: CIImage?
    var nextImage: CIImage? //image that first image is compared to
    var imageCount: Float = 1
    
    override init() {
        //getting the URL of metal library (Must define -fcikernel as a flag in Build settings for MSL)
        guard let url = Bundle.main.url(forResource: "default",
                                        withExtension: "metallib") else {
            fatalError("Check build settings.")
        }
        
        do { //initializing this function as a swift CIImage function from MSL file
            let data = try Data(contentsOf: url)
            
            kernel = try CIColorKernel(functionName: "average", fromMetalLibraryData: data)
        } catch {
            print(error.localizedDescription)
            fatalError("Function names don't match")
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //required to initialize using NSCoder
    
    func outputImage() -> CIImage? {
        
        guard //preventing operation on bad or missing data
            let currentImage = currentImage, let nextImage = nextImage
                
        else {
            print("Bad or missing image data")
            return nil
        }
        return kernel.apply(extent: currentImage.extent, arguments: [currentImage, nextImage, imageCount])
    }
    
}
