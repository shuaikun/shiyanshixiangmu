//
//  ITTImageWoodenCarveFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageWoodenCarveFilter.h"

@implementation ITTImageWoodenCarveFilter
/* 木雕
 * 算法：http://www.pcbookcn.com/article/2357.htm
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    int division = 100;
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
//            pixel.red = greyValue;
//            pixel.green = greyValue;
//            pixel.blue = greyValue;
//            
//            if (greyValue > division) {
//                pixel.red = 0;
//                pixel.green = 0;
//                pixel.blue = 0;
//            }else{
//                pixel.red = 255;
//                pixel.green = 255;
//                pixel.blue = 255;
//            }
//            [imageData setPixelValue:pixel];
//            
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
    
    int division = 100;
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
            pixel.red = greyValue;
            pixel.green = greyValue;
            pixel.blue = greyValue;
            
            if (greyValue > division) {
                pixel.red = 0;
                pixel.green = 0;
                pixel.blue = 0;
            }else{
                pixel.red = 255;
                pixel.green = 255;
                pixel.blue = 255;
            }
            [imageData setPixelValue:pixel];
            
        }   
    }    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"木雕";
}
@end
