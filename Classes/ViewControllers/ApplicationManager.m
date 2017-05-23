//
//  ApplicationManager.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ApplicationManager.h"
#import "ApplicationModel.h"
#import "ApplicationSectionHeader.h"

@implementation ApplicationManager

- (void)addObjectsFromArray:(NSArray *)resultsArray
{
    for (ApplicationSectionHeader *header in resultsArray) {
        for (ApplicationModel *application in header.applications) {
//            if (![self containsObject:application.itunesId])
            {
                [self addObjectWithIdentifier:header identifier:application.itunesId];
            }            
        }
    }
}
@end
