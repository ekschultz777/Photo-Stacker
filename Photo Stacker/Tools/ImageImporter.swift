//
//  ImageImporter.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 6/28/22.
//

import Cocoa

class ImageImporter: NSObject {
    
    private var imageFile: NSImage?
    
    func getImageForFileURL(fileURL: NSURL) -> NSImage {

        imageFile = NSImage.init(contentsOf: fileURL as URL)
            

        if imageFile?.isValid != nil {
            return self.imageFile!
        }
        
        else {
            imageFile = NSImage(systemSymbolName: "NSCaution", accessibilityDescription: "NSCaution")
            return imageFile!
        }
        
    }
    
//    func getThumbnailForFileURLString(imageURL: String, imageThumbnailSize: NSSize) -> NSImage {
//        //let imageFile = NSImage.init(contentsOfFile: imageName)
//        imageFile = NSImage.init(contentsOf: URL(fileURLWithPath: imageURL, isDirectory: true))
//        
//        //imageFile?.size = imageThumbnailSize
//        
//        if imageFile?.isValid != nil {
//            return self.imageFile!
//        }
//        
//        else {
//            imageFile = NSImage(systemSymbolName: "NSCaution", accessibilityDescription: "NSCaution")
//            return imageFile!
//        }
//    }
    
}




