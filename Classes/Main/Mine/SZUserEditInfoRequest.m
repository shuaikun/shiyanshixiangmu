//
//  SZUserEditInfoRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserEditInfoRequest.h"

@implementation SZUserEditInfoRequest

- (void)processResult
{
    [super processResult];
     NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSString *portrait = [dataDict objectForKey:@"portrait"];
        if(IS_STRING_NOT_EMPTY(portrait)){
            [self.handleredResult setObject:portrait forKey:@"portrait"];
        }
    }
}

@end
