//
//  SZSendCodeRequest.m
//  iTotemFramework
//
//  Created by Grant on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZSendCodeRequest.h"

@implementation SZSendCodeRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"user/getVeriCode.action"];
    return urlString;
}
@end
