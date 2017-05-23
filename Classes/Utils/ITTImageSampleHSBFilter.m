//
//  ITTImageSampleHSBFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageSampleHSBFilter.h"

@implementation ITTImageSampleHSBFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *processImage = [self adjustImage:_image withHue:0.8 saturation:1.2 brightness:0.8];
    [self onFilterProcessEnded];
    return processImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *processImageData = [self adjustImagePixelData:imageData withHue:0.8 saturation:1.2 brightness:0.8];
    [self onFilterProcessEnded];
    return processImageData;
}

+ (NSString*)getFilterName{
    return @"HSB测试";
}
@end
