//
//  SZGoodsStorelistRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZGoodsStorelistRequest.h"
#import "SZPreferentialModel.h"

@implementation SZGoodsStorelistRequest

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"dataDict is %@",dataDict);
        NSString *curpage = [dataDict objectForKey:@"curpage"];
        NSString *totlapage = [dataDict objectForKey:@"totalpage"];
        NSString *totalnum = [dataDict objectForKey:@"totalnum"];
        [self.handleredResult setObject:curpage forKey:@"curpage"];
        [self.handleredResult setObject:totlapage forKey:@"totlapage"];
        [self.handleredResult setObject:totalnum forKey:@"totalnum"];
        NSArray *goods_list = [dataDict objectForKey:@"goods_list"];
        if(goods_list && [goods_list isKindOfClass:[NSArray class]]){
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in goods_list){
                SZPreferentialModel *model = [[SZPreferentialModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
            }
            [self.handleredResult setObject:listsArray forKey:@"goods_list"];
        }
    }
}

@end
