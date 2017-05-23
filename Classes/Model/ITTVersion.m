//
//  ITTVersion.m
//  iTotemFramework
//
//  Created by Sword on 13-12-17.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTVersion.h"

@implementation ITTVersion

- (NSDictionary*)attributeMapDictionary
{
    return @{@"appid":@"trackId", @"version":@"version",
			 @"bundleIdentifier":@"bundleId",
			 @"versionDetails":@"releaseNotes",
			 @"applicationName":@"trackName",
			 @"storeUrl":@"trackViewUrl"};
}

- (id)init
{
	self = [super init];
	if (self) {
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		_bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
		_version = infoDictionary[@"CFBundleShortVersionString"];
		_countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        _builtinUpdate = TRUE;
	}
	return self;
}

- (NSString*)version
{
    NSAssert(nil != _version && [_version length], @"nil or empty version");
    return _version;
}
@end
