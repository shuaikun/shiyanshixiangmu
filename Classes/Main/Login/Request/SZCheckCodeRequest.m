//
//  SZCheckCodeRequest.m
//  iTotemFramework
//
//  Created by Grant on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCheckCodeRequest.h"

@implementation SZCheckCodeRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"user/verification.action"];
    return urlString;
}
@end
