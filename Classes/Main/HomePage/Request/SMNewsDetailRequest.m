//
//  SMNewsDetailRequest.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-5.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsDetailRequest.h"

@implementation SMNewsDetailRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"platform/executeEngineApp.do"];
    return urlString;
}
@end
