//
//  WindowController.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 7/4/22.
//

import Cocoa

class WindowController: NSWindowController {
    //Maximizes window on windowDidLoad() (At startup)
    override func windowDidLoad() {
        if let windowSize = window?.screen?.frame {
            window!.setFrame(windowSize, display: true)
        }
        
        super.windowDidLoad()
        window?.title = "Photo Stacker"
        window!.contentMinSize = NSSize(width: 600, height: 400)
    }
}
