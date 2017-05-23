//
//  AQCNewsManager.m
//  iTotemFramework
//
//  Created by admin on 13-1-27.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "AQCNewsManager.h"
#import "AQCNews.h"

@implementation AQCNewsManager

- (void)addObjectsFromArray:(NSArray *)resultsArray
{
    for (AQCNews *news in resultsArray)
    {
        [self.dataResultArray addObject:news];
    }
}

@end
