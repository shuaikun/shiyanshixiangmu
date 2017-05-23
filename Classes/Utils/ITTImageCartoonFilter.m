//
//  ITTImageCartoonFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageCartoonFilter.h"

@implementation ITTImageCartoonFilter

/* 卡通效果 
 * 算法：1.每个像素点rgb值取平均值 a = (r+g+b)/3 
 *      2.做a 的二值化：a = (a>128)? 255:0
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            
//            
//            int newAva = pixel.gray>128 ? 255 : 0;
//            
//            pixel.red = newAva;
//            pixel.green = newAva;
//            pixel.blue = newAva;
//            
//            [imageData setPixelValue:pixel];
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
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            
            
            int newAva = pixel.gray>128 ? 255 : 0;
            
            pixel.red = newAva;
            pixel.green = newAva;
            pixel.blue = newAva;
            
            [imageData setPixelValue:pixel];
        }
    }
    
    [self onFilterProcessEnded];
    return imageData;   
}

+ (NSString*)getFilterName{
    return @"漫画";
}
@end
