//
//  SZUserFriendsRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserFriendsRequest.h"
#import "SZUserFriendsModel.h"

@implementation SZUserFriendsRequest

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSArray *dataArray = [[self.handleredResult objectForKey:NETDATA] objectForKey:@"list"];
        if(dataArray && [dataArray isKindOfClass:[NSArray class]]){
//            NSLog(@"dataArray is %@",dataArray);
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in dataArray){
                SZUserFriendsModel *model = [[SZUserFriendsModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
            }
            [self.handleredResult setObject:listsArray forKey:@"listsArray"];
        }
    }
}

@end
