//
//  ViewController.swift
//  Photo Stacker
//
//  Created by Ted Schultz on 6/27/22.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate
{
    //Initializing threads
    let backgroundThread = DispatchQueue(label: "photostacker.background", qos: .background)
    
    //Outlets for image Views
    @IBOutlet weak var imageCollectionView: NSCollectionView!
    @IBOutlet weak var outputImageView: NSImageView!
    
    //Input variables
    var imageURLArray: [URL] = [] //Main image URL array for creating stacked image
    var imageArray: [NSImage] = [] //Main image array for creating

    //Output variables
    var finalCIImage = CIImage()
    var finalImage = NSImage()
    var mainCompletionHandler: ((CIImage) -> Void)? //variable to be used to run on the main thread for completion of image processing
    
    //initializing Processing Classes
    let importer = ImageImporter()
    let arrayProcessor = ImageArrayProcessor()
    let processingTools = ImageProcessingTools()
    
    //initializing image processing variables
    var exposure: Float = 0.5
    var gamma: Float = 0.75
    var noiseReduction: Float = 0
    var sharpness: Float = 0
    
    //Buttons:
    
    @IBAction func ImportButton(_ sender: NSButton) {
        let importPanel:NSOpenPanel = NSOpenPanel()
        importPanel.allowsMultipleSelection = true
        importPanel.canChooseFiles = true
        importPanel.canChooseDirectories = false
        importPanel.runModal() //runs the panel using last directory
        
        let chosenFiles = importPanel.urls
        
        backgroundThread.async { [weak self] in
            guard let self else { return }
            self.imageURLArray.append(contentsOf: chosenFiles)
            for i in self.imageURLArray {
                let imageFromURLArray = self.importer.getImageForFileURL(fileURL: i as NSURL)
                self.imageArray.append(imageFromURLArray)
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func exportButton(_ sender: NSButton) {
        
        let finalCIImageTemp = sendImageProcessingValues(ciimage: finalCIImage)
        let finalImageTemp = processingTools.toNSImage(ciimage: finalCIImageTemp)
        
        let exportPanel: NSSavePanel = NSSavePanel()
        exportPanel.nameFieldStringValue = "combined.jpg"
        exportPanel.runModal() //run the panel using last directory
        let destinationDirectory = exportPanel.url! //destination URL

        backgroundThread.async {
            let finalJPEGImage = self.processingTools.toJPEG(nsimage: finalImageTemp)
            try? finalJPEGImage.write(to: destinationDirectory)
        }
    }
    
    @IBAction func ClearAllButton(_ sender: Any) {
        removeAllImages()
        imageCollectionView.reloadData()
    }
    
    @IBAction func CreateStackedImageButton(_ sender: Any) {


        if !imageArray.isEmpty {
            arrayProcessor.addImages(images: imageArray)
            arrayProcessor.processImagesFromArray(completionHandler: mainCompletionHandler)
            finalCIImage = arrayProcessor.outputImage
            finalImage = processingTools.toNSImage(ciimage: finalCIImage)
            
            DispatchQueue.main.async {
                self.outputImageView.image = self.finalImage
            }
        }
        else {
            outputImageView.image = nil
        }
            
    }
    
    func removeAllImages() { //remove all images clears URL and image arrays and reloads collection view
        self.imageURLArray.removeAll()
        self.imageArray.removeAll()
    }
    
    //Image Processing Tools:
    
    @IBAction func ExposureSlider(_ sender: NSSlider) {
        
        exposure = sender.floatValue
        var finalCIImageTemp = finalCIImage
        
        finalCIImageTemp = sendImageProcessingValues(ciimage: finalCIImageTemp)
        let finalImageTemp = processingTools.toNSImage(ciimage: finalCIImageTemp)
        
        outputImageView.image = finalImageTemp
        
    }
    
    
    @IBAction func GammaSlider(_ sender: NSSlider) {
        
        gamma = sender.floatValue
        var finalCIImageTemp = finalCIImage
        
        finalCIImageTemp = sendImageProcessingValues(ciimage: finalCIImageTemp)
        let finalImageTemp = processingTools.toNSImage(ciimage: finalCIImageTemp)
        
        outputImageView.image = finalImageTemp
        
    }
    
    @IBAction func NoiseReductionSlider(_ sender: NSSlider) {
        
        noiseReduction = sender.floatValue
        var finalCIImageTemp = finalCIImage
        
        finalCIImageTemp = sendImageProcessingValues(ciimage: finalCIImageTemp)
        let finalImageTemp = processingTools.toNSImage(ciimage: finalCIImageTemp)
        
        outputImageView.image = finalImageTemp
        
    }
    
    @IBAction func SharpnessSlider(_ sender: NSSlider) {
        
        sharpness = sender.floatValue
        var finalCIImageTemp = finalCIImage
        
        finalCIImageTemp = sendImageProcessingValues(ciimage: finalCIImageTemp)
        let finalImageTemp = processingTools.toNSImage(ciimage: finalCIImageTemp)
        
        outputImageView.image = finalImageTemp
        
    }
    
    //Outlets to be reset using the revert button
    @IBOutlet weak var ExposureSliderOutlet: NSSlider!
    
    @IBOutlet weak var GammaSliderOutlet: NSSlider!

    @IBOutlet weak var NoiseReductionSliderOutlet: NSSlider!
    
    @IBOutlet weak var SharpnessSliderOutlet: NSSlider!
    
    @IBAction func RevertButton(_ sender: NSButton) {
        
        sharpness = 0
        noiseReduction = 0
        exposure = 0.5
        gamma = 0.75
        
        NoiseReductionSliderOutlet.doubleValue = 0
        SharpnessSliderOutlet.doubleValue = 0
        ExposureSliderOutlet.doubleValue = 0.5
        
        outputImageView.image = finalImage
        
    }
    
    func sendImageProcessingValues(ciimage: CIImage) -> CIImage {
        var ciimage = ciimage
        ciimage = processingTools.sharpnessAdjust(inputImage: ciimage, sharpnessValue: sharpness)!
        ciimage = processingTools.exposureAdjust(inputImage: ciimage, exposureAmount: exposure)!
        ciimage = processingTools.gammaAdjust(inputImage: ciimage, gammaLevel: gamma)!
        ciimage = processingTools.noiseReduction(inputImage: ciimage, reductionAmount: noiseReduction)!
        return ciimage
    }
    
    //Number of items in collectionView based on number of images in array
    func collectionView(_ itemForObjectAtcollectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLArray.count
    }
    
    //Number of sections in collectionView; this will default to and remain 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    //Adds items to image collection view
    func collectionView(_ itemForObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let itemIdentifier = NSUserInterfaceItemIdentifier.init(rawValue: "CollectionViewImageItem") //Collection View Item identifier
        
        //initializing a new Collection View Item and setting collection view item at index path to this new item
        let imageItem = ImageItem.init()
        imageItem.collectionView?.makeItem(withIdentifier: itemIdentifier, for: indexPath)

        let imageURLAtIndex: [URL] = imageURLArray
        imageItem.addImageViewForURL(imageURL: imageURLAtIndex[indexPath.item] as NSURL)

        return imageItem //returns collection view item at index path
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        //Could implement delete keystroke event handler to delete item at index path
        print("item selected")
        
    }

    //Setting up collection view programmatically instead of using AutoLayout
    //AutoLayout and constraints is used for overall collection view, buttons, labels, etc.
    func collectionViewLayout() {

        let imageCollectionViewLayout = NSCollectionViewFlowLayout() //Used to create image grid (Grid layout creates columns or rows
        
        imageCollectionViewLayout.itemSize = NSSize(width: 100, height: 100)
        imageCollectionViewLayout.sectionInset = NSEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
        
        imageCollectionViewLayout.minimumInteritemSpacing = 10
        imageCollectionViewLayout.minimumLineSpacing = 10
        
        imageCollectionView.collectionViewLayout = imageCollectionViewLayout
        view.wantsLayer = true
        imageCollectionView.layer?.backgroundColor = NSColor.systemGray.cgColor
      }
    
    override func viewDidLoad() {
        
        //setup before viewController is loaded into memory:
        
        //Collection view layout, border, and color
        collectionViewLayout()
        imageCollectionView.isSelectable = true
        imageCollectionView.layer?.backgroundColor = nil
        imageCollectionView.layer?.borderWidth = 1
        imageCollectionView.layer?.borderColor = NSColor.windowBackgroundColor.cgColor
        
        //Output image view border, color, and scaling
        outputImageView.layer?.backgroundColor = nil
        outputImageView.wantsLayer = true
        outputImageView.layer?.borderWidth = 1
        outputImageView.layer?.borderColor = NSColor.windowBackgroundColor.cgColor
        outputImageView.imageScaling = .scaleProportionallyDown
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageCollectionView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
