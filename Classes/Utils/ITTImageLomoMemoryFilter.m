//
//  ITTImageLomoMemoryFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageLomoMemoryFilter.h"
#import "ITTImageMemoryFilter.h"
#import "UIImage+ITTAdditions.h"

@implementation ITTImageLomoMemoryFilter

- (UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
    ITTImageMemoryFilter *memoryFilter = [[ITTImageMemoryFilter alloc] initWithImage:_image];
    UIImage *memoryImage = [memoryFilter getFilteredImage];
    [memoryFilter release];
    
    UIImage *lomoCover = [[UIImage imageNamed:@"LomoCover.png"] imageScaleToFillInSize:_image.size];
    UIImage *lomoImage = [self blendImagesWithBottomImage:memoryImage topImage:lomoCover blendMode:kCGBlendModeNormal alpha:1]; 
    [self onFilterProcessEnded];
    return lomoImage;
}
+ (NSString*)getFilterName{
    return @"LOMO旧照片";
}

@end
