//
//  ITTImageBlurFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageBlurFilter.h"

@implementation ITTImageBlurFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    UIImage *processedImage = [self blurWithGaussFilter:_image];
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    ITTImagePixelData *processedImageData = [self blurWithGaussFilterData:imageData];
    [self onFilterProcessEnded];
    return processedImageData;
}

+ (NSString*)getFilterName{
    return @"模糊";
}
@end
