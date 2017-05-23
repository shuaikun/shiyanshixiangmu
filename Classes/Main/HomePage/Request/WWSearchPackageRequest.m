//
//  WWSearchPackageRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-20.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWSearchPackageRequest.h"

@implementation WWSearchPackageRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"package/search"];
    return urlString;
}

@end
