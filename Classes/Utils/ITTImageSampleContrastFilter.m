//
//  ITTImageSampleContrastFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#include <math.h> 
#import "ITTImageSampleContrastFilter.h"
@interface ITTImageSampleContrastFilter(){
    float _contrastChange;
}

@end
@implementation ITTImageSampleContrastFilter
- (void)dealloc{
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image withContrastChange:(CGFloat)contrastChange{
    self = [super initWithImage:image];
    if (self) {
        _contrastChange = contrastChange;
    }
    return self;
}

/* 调整对比度
 * 算法：幂率（伽马）变换
 * s = cr^gama
 * gama:0 - 25, 1<gama<25时，对比度增大， 0<gama<1时，对比度变小
 */
- (void)adjustImagePixelData:(ITTImagePixelData *)imageData withContrastGama:(CGFloat)contrastGama{
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col < imageData.width; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            pixel.red = pow(pixel.red/255.0,contrastGama) * 255 ;//幂运算
            pixel.green = pow(pixel.green/255.0,contrastGama) * 255 ;
            pixel.blue = pow(pixel.blue/255.0,contrastGama) * 255 ;
            [imageData setPixelValue:pixel];
        }
    }
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    [self adjustImagePixelData:imageData withContrastGama:_contrastChange];
    [self onFilterProcessEnded];
    return imageData;
}


- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    //使用默认算法
    //UIImage *processImage = [self adjustImage:_image withContrast:_contrastChange];
    
    //使用幂率（伽马）变换算法
    UIImage *processImage = [[self getFilteredImageData] generateImage];
    [self onFilterProcessEnded];
    return processImage;
}

+ (NSString*)getFilterName{
    return @"对比度测试";
}


@end
