//
//  ApplicationSearchDataRequest.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ApplicationSearchDataRequest.h"
#import "ApplicationModel.h"
#import "ApplicationSectionHeader.h"

@implementation ApplicationSearchDataRequest

- (NSString*)getRequestUrl
{
    return @"https://itunes.apple.com/search?term=qq&country=cn&entity=software";
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

- (NSString*)dumpyResponseString
{
	return [NSString stringWithFileInMainBundle:@"applist" ofType:@"txt"];
}

- (void)processResult
{
    /*
       we don't call super processResult because this is a demo request, otherwise you have to
       call super
       [super processResult];
     */
    NSArray *appdicArray = self.handleredResult[@"results"];
    if (appdicArray && [appdicArray count]) {
        self.result = [[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""];
        NSMutableArray *applications = [NSMutableArray array];
        for (NSDictionary *appdic in appdicArray) {
            ApplicationModel *application = [[ApplicationModel alloc] initWithDataDic:appdic];
            ApplicationSectionHeader *sectionHeader = [[ApplicationSectionHeader alloc] init];
            sectionHeader.applications = @[application];
            [applications addObject:sectionHeader];
        }
        self.handleredResult = [NSMutableDictionary dictionaryWithObjectsAndKeys:applications, KEY_APPLICATION, nil];
    }
}

@end
