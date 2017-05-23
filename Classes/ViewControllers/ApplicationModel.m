//
//  ApplicationModel.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel

- (NSDictionary*)attributeMapDictionary
{
    return @{@"itunesId":@"trackId", @"name":@"trackName", @"icon":@"artworkUrl60", @"introduction":@"description"};
}
@end
