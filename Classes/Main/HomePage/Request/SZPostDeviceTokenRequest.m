//
//  SZPostDeviceTokenRequest.m
//  iTotemFramework
//
//  Created by Grant on 14-5-4.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZPostDeviceTokenRequest.h"

@implementation SZPostDeviceTokenRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
}
@end
