//
//  WWGroupDataRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWGroupDataRequest.h"

@implementation WWGroupDataRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"common/catelog.action"];
    return urlString;
}
@end
