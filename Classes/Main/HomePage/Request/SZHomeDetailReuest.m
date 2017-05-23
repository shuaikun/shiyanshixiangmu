//
//  SZHomeDetailReuest.m
//  iTotemFramework
//
//  Created by Grant on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZHomeDetailReuest.h"
@implementation SZHomeDetailReuest


- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"%@",dataDict);
    }

}
@end
