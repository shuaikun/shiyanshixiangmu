//
//  VersionCheckDataRequest.m
//  iTotemFramework
//
//  Created by Sword on 13-12-20.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "VersionCheckDataRequest.h"
#import "ITTVersion.h"

@implementation VersionCheckDataRequest

- (NSString*)getRequestUrl
{
    return @""; //replace with your request url, return empty string for demo
}

- (BOOL)useDumpyData
{
    return TRUE;
}

- (NSString*)dumpyResponseString
{
	return [NSString stringWithFileInMainBundle:@"version" ofType:@"txt"];
}

- (void)processResult
{
    [super processResult];
    /*
     *proce your data here, encapsulate to an ITTVersion instance
     */
    ITTVersion *version = [[ITTVersion alloc] init];
    NSDictionary *versionDic = self.handleredResult[@"result"];
    version.appid = versionDic[@"appid"];
    version.bundleIdentifier = versionDic[@"bundleid"];
    version.storeUrl = versionDic[@"itunes_url"];
    version.version = versionDic[@"version"];
    self.handleredResult = @{@"KEY_VERSION":version};
}

@end
