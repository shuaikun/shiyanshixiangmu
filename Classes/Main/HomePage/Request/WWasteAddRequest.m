//
//  WWasteAddRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-26.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWasteAddRequest.h"

@implementation WWasteAddRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"package/wasteadd.action"];
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
