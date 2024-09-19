# Photo-Stacker

## Overview
This project is designed to provide a high-performance macOS application that averages multiple images to create composite photos averaged from a provided list of images.

## Features
- **Photo Averaging**: Average multiple images by first aligning them, and then averaging them leveraging GPU hardware acceleration. This can be done to remove unwanted artifacts, reduce noise, create HDR images, etc.
- **Metal Performance**: Harnesses the power of Metal for fast, GPU-accelerated image processing.
- **Image Adjustment Tools**: Adjust image exposure, gamma, sharpness, and noise reduction.
- **Export**: Exports the image to the specified location.

## Getting Started
### Prerequisites
- macOS 11.0 or higher
- Build in Xcode 15.4

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ekschultz777/Photo-Stacker.git
   cd Photo-Stacker
   ```

2. Open the project in Xcode:
   ```bash
   open Photo-Stacker.xcodeproj
   ```

3. Build and run the app using Xcode.

### Usage
1. Launch the app.
2. Click _Import Photos_ to import photos. (You may add more as well or clear the current selection)
3. Click _Stack Images_.
4. Adjust any image settings as needed, such as exposure or gamma.
5. Use the _Export_ button to save your final image.

## Contributing
Please branch the repository and submit a pull request.
