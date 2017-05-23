//
//  ITTImagePencilFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageOilPaintFilter.h"
#import "ITTImageHistogramAjustmentFilter.h"
#import "ITTImageBlackWhiteFilter.h"

@implementation ITTImageOilPaintFilter

- (UIImage*)processOilPaintEffectWithImage:(UIImage*)image{
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *oilPaintImageData=  [self processOilPaintEffectWithImageData:imageData];
    return [oilPaintImageData generateImage];
    
}

- (ITTImagePixelData*)processOilPaintEffectWithImageData:(ITTImagePixelData*)imagePixelData{
    NSInteger randomRange = 5;
    for(GLuint row = 0; row < imagePixelData.height;row++){
        for (GLuint col = 0; col <imagePixelData.width; col++) {
            NSInteger randomRow = row - 1 + row % randomRange;
            NSInteger randomCol = col - 1 + col % randomRange;
            if (randomRow < 0) {
                randomRow = 0;
            }
            if (randomCol < 0) {
                randomCol = 0;
            }
            if (randomRow >= imagePixelData.height) {
                randomRow = imagePixelData.height - 1;
            }
            if (randomCol >= imagePixelData.width) {
                randomCol = imagePixelData.width - 1;
            }
            ITTImagePixel pixel = [imagePixelData getPixelAtPostion:ITTImagePixelPositionMake(randomRow, randomCol)];
            [imagePixelData setPixelValue:pixel atPosition:ITTImagePixelPositionMake(row, col)];
        }
    }
    return imagePixelData;
}

/* 雕刻效果
 * 算法：http://www.pcbookcn.com/article/2357.htm
 */
- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *smoothImage = [self blurWithGaussFilter:_image];
    UIImage *sharpenImage = [self sharpenWithLaplacian:smoothImage];
    UIImage *processedImage = [self processOilPaintEffectWithImage:sharpenImage];
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
    ITTImagePixelData *processedImageData = [self processOilPaintEffectWithImageData:sharpenImageData];
    
    [self onFilterProcessEnded];
    return processedImageData;
}

+ (NSString*)getFilterName{
    return @"油画";
}
@end
