//
//  ITTImageScanlineFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageScanlineFilter.h"

@implementation ITTImageScanlineFilter


/* 扫描线效果 
 * 算法： 每隔一行进行处理，处理方法：分别增强rgb的值
 * discuss:可调整间隔行数调整效果
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    int skipLineNum = 3;
//    
//    for(GLuint row = 0;row< imageData.height;row+= skipLineNum){
//        
//        for (GLuint col = 0; col<imageData.width; col++) {
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            
//            int rr = pixel.red *2;
//            pixel.red = rr > 255 ? 255 : rr;
//            int gg = pixel.green *2;
//            pixel.green = gg > 255 ? 255 : gg;
//            int bb = pixel.blue *2;
//            pixel.blue = bb > 255 ? 255 : bb;
//            
//            [imageData setPixelValue:pixel];
//        }
//    }

    ITTImagePixelData *imageData = [self getFilteredImageData];
    
    UIImage *processedImage = [imageData generateImage];
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData*)getFilteredImageData{
   
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    
    int skipLineNum = 3;
    
    for(GLuint row = 0;row< imageData.height;row+= skipLineNum){
        
        for (GLuint col = 0; col<imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            
            int rr = pixel.red *2;
            pixel.red = rr > 255 ? 255 : rr;
            int gg = pixel.green *2;
            pixel.green = gg > 255 ? 255 : gg;
            int bb = pixel.blue *2;
            pixel.blue = bb > 255 ? 255 : bb;
            
            [imageData setPixelValue:pixel];
        }
    }
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"扫描线";
}
@end
