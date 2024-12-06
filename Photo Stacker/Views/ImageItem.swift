//
//  ImageItem.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 6/28/22.
//

import Cocoa

class ImageItem: NSCollectionViewItem {
    
    private var newImageViewRect = NSRect.init(origin: NSPoint.zero, size: NSSize.init(width: 100, height: 100))
    private let newImageSize = NSSize(width: 100, height: 100)
    
    func addImageViewForURL(imageURL: NSURL) {
        
        let imageImporter = ImageImporter.init()

        let newImageView = NSImageView.init(frame: newImageViewRect) //creates NSImageView based on image size
        
        newImageView.image = imageImporter.getImageForFileURL(fileURL: imageURL)
        
        self.view.addSubview(newImageView) //Adds new NSImageView to ImageItem NSView
        newImageViewRect.size = imageImporter.getImageForFileURL(fileURL: imageURL).size
        
        print("Image loaded to view!")
    }
    
    override var isSelected: Bool {
        didSet {
            //view.layer?.backgroundColor = isSelected ? NSColor.darkGray.cgColor : nil
            view.layer?.borderWidth = isSelected ? 5 : 0
            
        }
      }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.layer?.backgroundColor = nil
        view.layer?.borderWidth = 0
        view.layer?.borderColor = NSColor.darkGray.cgColor
        
        view.wantsLayer = true
        
        // Do view setup here.
    }
    
    
}
