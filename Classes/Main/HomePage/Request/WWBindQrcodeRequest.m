//
//  WWBindQrcodeRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-23.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWBindQrcodeRequest.h"

@implementation WWBindQrcodeRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"package/bind.action"];
    return urlString;
}

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
    }
    
}
@end
