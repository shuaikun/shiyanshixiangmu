//
//  ITTImageInfo.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageInfo.h"

@implementation ITTImageInfo

+(NSString*)getImageUrlWithSourceUrl:(NSString*)url targetWidth:(int)imageWidth
{
    NSRange range = [url rangeOfString:@"950.jpg"];
    if (range.location != NSNotFound) {
        return [url stringByReplacingOccurrencesOfString:@"950.jpg" withString:[NSString stringWithFormat:@"%d.jpg", imageWidth]];
    }else{
        range = [url rangeOfString:@"src.jpg"];
        if (range.location != NSNotFound) {
            return [url stringByReplacingOccurrencesOfString:@"src.jpg" withString:[NSString stringWithFormat:@"%d.jpg", imageWidth]];
        }else{
            return url;
        }
    }
}

- (NSDictionary*)attributeMapDictionary
{
	return @{@"title": @"script"
            ,@"url": @"img"
            ,@"smallUrl": @"img_small"};
}



@end
