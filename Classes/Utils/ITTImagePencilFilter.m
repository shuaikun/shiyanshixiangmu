//
//  ITTImagePencilFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImagePencilFilter.h"
#import "ITTImageHistogramAjustmentFilter.h"
#import "ITTImageBlackWhiteFilter.h"

@implementation ITTImagePencilFilter

- (UIImage*)processPencilEffectWithImage:(UIImage*)image{
    //转铅笔画
    int sensitivity = 9;
    
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            BOOL isEdgeVertically = NO;
            BOOL isEdgeHorizontally = NO;
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            // carve horizontally
            if (col > 0  && col < imageData.width-1) {
                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
                int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
                int nextGreyValue = nextPixel.red * 0.3 + nextPixel.green * 0.6 + nextPixel.blue * 0.1;
                if (nextGreyValue - greyValue > sensitivity) {
                    isEdgeHorizontally = YES;
                }
            }
            // carve horizontally
            if (row > 0  && row < imageData.height-1) {
                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col)];;
                int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
                int nextGreyValue = nextPixel.red * 0.3 + nextPixel.green * 0.6 + nextPixel.blue * 0.1;
                if (nextGreyValue - greyValue > sensitivity) {
                    isEdgeVertically = YES;
                }
            }
            if (isEdgeVertically || isEdgeHorizontally) {
                pixel.red = pixel.gray;
                pixel.green = pixel.gray;
                pixel.blue = pixel.gray;
            }else {
                pixel.red = 255;
                pixel.green = 255;
                pixel.blue = 255;
            }
            [imageData setPixelValue:pixel];
        }
    }
    
    return [imageData generateImage];

}

- (ITTImagePixelData*)processPencilEffectWithImageData:(ITTImagePixelData*)imagePixelData{
    //转铅笔画
    int sensitivity = 9;
    
    ITTImagePixelData *imageData = imagePixelData;
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            BOOL isEdgeVertically = NO;
            BOOL isEdgeHorizontally = NO;
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            // carve horizontally
            if (col > 0  && col < imageData.width-1) {
                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
                int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
                int nextGreyValue = nextPixel.red * 0.3 + nextPixel.green * 0.6 + nextPixel.blue * 0.1;
                if (nextGreyValue - greyValue > sensitivity) {
                    isEdgeHorizontally = YES;
                }
            }
            // carve horizontally
            if (row > 0  && row < imageData.height-1) {
                ITTImagePixel nextPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col)];;
                int greyValue = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
                int nextGreyValue = nextPixel.red * 0.3 + nextPixel.green * 0.6 + nextPixel.blue * 0.1;
                if (nextGreyValue - greyValue > sensitivity) {
                    isEdgeVertically = YES;
                }
            }
            if (isEdgeVertically || isEdgeHorizontally) {
                pixel.red = pixel.gray;
                pixel.green = pixel.gray;
                pixel.blue = pixel.gray;
            }else {
                pixel.red = 255;
                pixel.green = 255;
                pixel.blue = 255;
            }
            [imageData setPixelValue:pixel];
        }
    }
    
    return imageData;
}

/* 雕刻效果 
 * 算法：http://www.pcbookcn.com/article/2357.htm
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *smoothImage = [self blurWithGaussFilter:_image];
    UIImage *sharpenImage = [self sharpenWithLaplacian:smoothImage];
    UIImage *processedImage = [self processPencilEffectWithImage:sharpenImage];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    ITTImagePixelData *smoothImageData = [self blurWithGaussFilterData:imageData];
//    ITTImagePixelData *sharpenImageData = [self sharpenWithLaplacianData:smoothImageData];
//    ITTImagePixelData *processedImageData = [self processPencilEffectWithImageData:sharpenImageData];
//    UIImage *processedImage = [processedImageData generateImage];
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData *)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *smoothImageData = [self blurWithGaussFilterData:imageData];
    ITTImagePixelData *sharpenImageData = [self sharpenWithLaplacianData:smoothImageData];
    ITTImagePixelData *processedImageData = [self processPencilEffectWithImageData:sharpenImageData];
    
    [self onFilterProcessEnded];
    return processedImageData;
}

+ (NSString*)getFilterName{
    return @"铅笔画";
}
@end
