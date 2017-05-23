//
//  SMNewsRequest.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsRequest.h"

@implementation SMNewsRequest

- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"platform/executeEngineApp.do"];
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
