//
//  ITTImageRevertBlackWhiteFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageRevertBlackWhiteFilter.h"

@implementation ITTImageRevertBlackWhiteFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            pixel.red = 255 - pixel.gray;
//            pixel.green = 255 - pixel.gray;
//            pixel.blue = 255 - pixel.gray;
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
            pixel.red = 255 - pixel.gray;
            pixel.green = 255 - pixel.gray;
            pixel.blue = 255 - pixel.gray;
            
            [imageData setPixelValue:pixel];
        }
    }    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"反黑白";
}
@end
