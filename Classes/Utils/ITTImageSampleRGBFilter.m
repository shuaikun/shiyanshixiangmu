//
//  ITTImageSampleRGBFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageSampleRGBFilter.h"

@implementation ITTImageSampleRGBFilter

- (void)dealloc{
    [super dealloc];
}

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *processImage = [self adjustImage:_image withRed:1.3 green:1 blue:0.5];
    [self onFilterProcessEnded];
    return processImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *sharpenImageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *processImageData = [self adjustImagePixelData:sharpenImageData withRed:1.3 green:1 blue:0.5];
    [self onFilterProcessEnded];
    return processImageData;
}

+ (NSString*)getFilterName{
    return @"RGB调整测试";
}
@end
