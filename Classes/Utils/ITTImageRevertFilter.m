//
//  ITTImageRevertFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageRevertFilter.h"

@implementation ITTImageRevertFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            pixel.red = 255 - pixel.red;
//            pixel.green = 255 - pixel.green;
//            pixel.blue = 255 - pixel.blue;
//            
//            [imageData setPixelValue:pixel];
//            
//        }
//    }
    
    ITTImagePixelData *imageData = [self getFilteredImageData];
    
    UIImage *my_Image = [imageData generateImage];
    [self onFilterProcessEnded];
    return my_Image;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            pixel.red = 255 - pixel.red;
            pixel.green = 255 - pixel.green;
            pixel.blue = 255 - pixel.blue;
            
            [imageData setPixelValue:pixel];
        }
    }    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"反转";
}
@end
