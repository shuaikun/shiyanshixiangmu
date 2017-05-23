//
//  SZLocationSuggetRequest.m
//  iTotemFramework
//
//  Created by Grant on 14-5-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZLocationSuggestRequest.h"
NSString *const SZLocationSuggestCityCode = @"SZLocationSuggestCityCode";
@implementation SZLocationSuggestRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
}
@end
