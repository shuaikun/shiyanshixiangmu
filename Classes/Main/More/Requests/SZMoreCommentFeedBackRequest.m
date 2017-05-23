//
//  SZMoreCommentFeedBack.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-25.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMoreCommentFeedBackRequest.h"

@implementation SZMoreCommentFeedBackRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
}

@end
