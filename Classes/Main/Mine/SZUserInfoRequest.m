//
//  SZUserInfoRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserInfoRequest.h"
#import "SZUserInfoModel.h"

@implementation SZUserInfoRequest

- (void)processResult
{
    [super processResult];
//    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"dataDict is %@",dataDict);
        SZUserInfoModel *model = [[SZUserInfoModel alloc] initWithDataDic:dataDict];
        [self.handleredResult setObject:model forKey:@"model"];
    }
}

@end
