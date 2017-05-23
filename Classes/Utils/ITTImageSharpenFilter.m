//
//  ITTImageSharpenFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageSharpenFilter.h"

@implementation ITTImageSharpenFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    //UIImage *processedImage = [self sharpen:_image withSharpeness:0.7];
    UIImage *sharpenImage = [self sharpenWithLaplacian:_image];
    UIImage *processedImage = [self adjustImage:sharpenImage withHue:1 saturation:1 brightness:1.5];
        
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    UIImage *sharpenImage = [self sharpenWithLaplacian:_image];
    ITTImagePixelData *sharpenImageData = [[[ITTImagePixelData alloc] initWithImage:sharpenImage] autorelease];
    ITTImagePixelData *processedImageData = [self adjustImagePixelData:sharpenImageData withHue:1 saturation:1 brightness:1.5];
    [self onFilterProcessEnded];
    return processedImageData;
}

+ (NSString*)getFilterName{
    return @"锐化";
}
@end
