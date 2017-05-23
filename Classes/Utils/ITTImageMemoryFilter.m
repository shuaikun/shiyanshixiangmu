//
//  ITTImageMemoryFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageMemoryFilter.h"

@implementation ITTImageMemoryFilter

/* 老照片效果 
 * 算法： 1.每个像素点rgb值取平均值 a = (r+g+b)/3 ,r = g = b = a
 *       2.增强红绿值:r += r*2 ,g = g*2
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            
//            pixel.red = pixel.gray;
//            pixel.green = pixel.gray;
//            pixel.blue = pixel.gray;
//            
//            pixel.red += pixel.red*2;
//            pixel.green = pixel.green*2;
//            
//            if(pixel.red > 255){
//                pixel.red = 255;
//            }
//            if(pixel.green > 255){
//                pixel.green = 255;
//            }
//            
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
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            
            pixel.red = pixel.gray;
            pixel.green = pixel.gray;
            pixel.blue = pixel.gray;
            
            pixel.red += pixel.red*2;
            pixel.green = pixel.green*2;
            
            if(pixel.red > 255){
                pixel.red = 255;
            }
            if(pixel.green > 255){
                pixel.green = 255;
            }
            
            [imageData setPixelValue:pixel];
            
        }
    }
    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"复古";
}
@end
