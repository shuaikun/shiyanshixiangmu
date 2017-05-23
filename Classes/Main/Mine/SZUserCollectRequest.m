//
//  SZUserCollectRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserCollectRequest.h"
#import "SZActivityMerchantModel.h"

@implementation SZUserCollectRequest

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"dataDict is %@",dataDict);
        NSString *curpage = [dataDict objectForKey:@"curpage"];
        NSString *totalpage = [dataDict objectForKey:@"totalpage"];
        NSString *totalnum = [dataDict objectForKey:@"totalnum"];
        [self.handleredResult setObject:curpage forKey:@"curpage"];
        [self.handleredResult setObject:totalpage forKey:@"totalpage"];
        [self.handleredResult setObject:totalnum forKey:@"totalnum"];
        NSArray *store_list = [dataDict objectForKey:@"store_list"];
        if(store_list && [store_list isKindOfClass:[NSArray class]]){
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in store_list){
                SZActivityMerchantModel *model = [[SZActivityMerchantModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
            }
            [self.handleredResult setObject:listsArray forKey:@"store_list"];
        }
    }
}

@end
