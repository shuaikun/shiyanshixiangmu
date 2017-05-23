//
//  ITTImageCarveFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageCarveFilter.h"

@implementation ITTImageCarveFilter

/* 雕刻效果 
 * 算法：http://dev.yesky.com/SoftChannel/72342371928637440/20050105/1896848.shtml
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    int brightness = 127;
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        
//        for (GLuint col = 0; col< imageData.width; col++) {
//            // carve horizontally
//            if (col > 0  && col < imageData.width-1) {
//                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//                
//                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
//                pixel.red = nextPixel.red - pixel.red + brightness;
//                pixel.green = nextPixel.green - pixel.green + brightness;
//                pixel.blue = nextPixel.blue - pixel.blue + brightness;
//                [imageData setPixelValue:pixel];
//            }
//        }
//    }

    ITTImagePixelData *imageData = [self getFilteredImageData];
    
    UIImage *processedImage = [imageData generateImage];
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData *)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    
    int brightness = 127;
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col< imageData.width; col++) {
            // carve horizontally
            if (col > 0  && col < imageData.width-1) {
                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
                
                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
                pixel.red = nextPixel.red - pixel.red + brightness;
                pixel.green = nextPixel.green - pixel.green + brightness;
                pixel.blue = nextPixel.blue - pixel.blue + brightness;
                [imageData setPixelValue:pixel];
            }
        }
    }
    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"雕刻";
}
@end
