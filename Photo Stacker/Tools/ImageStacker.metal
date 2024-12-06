//
//  ImageAverage.metal
//  Photo Stacker
//
//  Created by Ted Schultz on 7/9/22.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;

extern "C" { namespace coreimage {
    // Used to take the average of each pixel compared to another images pixel of the same location while keeping track of how many images have already been averaged. float4 data type is used to represent r, g, b, and luma
    float4 average(sample_t currentImage, sample_t nextImage, float imageCount) {
    
        // sample_t is "a sample value from a CIImage represented by a 4D 32-bit floating-point vector. Use as a parameter type only for representing a sample from an image. Otherwise behaves as a float4." See file: MetalCIKLReference6.pdf
        float4 averagedImages = ((currentImage * imageCount) + nextImage) / (imageCount + 1); //calculating weighted average to make random data less significant
        
        // float4 averagedImages = (currentImage + nextImage) / (imageCount + 1); // imageCount will begin at 0 so add 1
        averagedImages = float4(averagedImages.rgb, 1);
        
        return averagedImages;
    }
}}
