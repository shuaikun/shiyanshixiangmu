//
//  ITTImageSampleMaskFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageSampleMaskFilter.h"
#import "UIImage+ITTAdditions.h"

@implementation ITTImageSampleMaskFilter

- (void)dealloc{
    [super dealloc];
}

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *processImage = [self adjustImage:_image withRed:1.5 green:1.5 blue:1 mask:_maskImage];
    
    //UIImage *mask = [_maskImage imageScaleToFillInSize:_image.size];
    //return [self blendImagesWithBottomImage:_image topImage:mask blendMode:kCGBlendModeNormal alpha:1];    
    [self onFilterProcessEnded];
    
    return processImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *maskData = [[[ITTImagePixelData alloc] initWithImage:_maskImage] autorelease];
    ITTImagePixelData *processImageData = [self adjustImagePixelData:imageData withRed:1.5 green:1.5 blue:1 mask:maskData];
    [self onFilterProcessEnded];
    return processImageData;
}

+ (NSString*)getFilterName{
    return @"效果蒙板测试";
}
@end
