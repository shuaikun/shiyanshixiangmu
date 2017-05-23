//
//  SZUserPhonebookRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserPhonebookRequest.h"
#import "SZUserPhoneBookModel.h"

@implementation SZUserPhonebookRequest

- (void)processResult
{
    [super processResult];
//    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSArray *dataArray = [self.handleredResult objectForKey:NETDATA];
        if(dataArray && [dataArray isKindOfClass:[NSArray class]]){
//            NSLog(@"dataArray is %@",dataArray);
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in dataArray){
                SZUserPhoneBookModel *model = [[SZUserPhoneBookModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
            }
            [self.handleredResult setObject:listsArray forKey:@"listsArray"];
        }
    }
}

@end
