//
//  WWUnbindQrcodeRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-28.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWUnbindQrcodeRequest.h"

@implementation WWUnbindQrcodeRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"package/unbind.action"];
    return urlString;
}
@end
