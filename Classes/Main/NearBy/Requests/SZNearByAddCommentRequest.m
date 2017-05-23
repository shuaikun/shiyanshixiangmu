//
//  SZNearByAddCommentRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByAddCommentRequest.h"

@implementation SZNearByAddCommentRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
}
@end
