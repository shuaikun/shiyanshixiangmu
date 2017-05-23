//
//  SZNearByMerchantListRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByMerchantListRequest.h"
#import "SZActivityMerchantModel.h"

NSString *storelist = @"store_list";
@implementation SZNearByMerchantListRequest
- (void)processResult
{
    [super processResult];
    if (self.result.isSuccess) {
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSMutableArray *storeArray = [NSMutableArray array];
        if ([[dataDict objectForKey:storelist]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dataDict objectForKey:storelist]) {
                SZActivityMerchantModel *model = [[SZActivityMerchantModel alloc]initWithDataDic:dic];
                [storeArray addObject:model];
            }
        }
        NSString *currentPage = [dataDict objectForKey:@"curpage"];
        NSString *totalPage = [dataDict objectForKey:@"totalpage"];
        NSString *totalNumber = [dataDict objectForKey:@"totalnum"];
        [self.handleredResult setObject:storeArray forKey:NETDATA];
        [self.handleredResult setObject:currentPage forKey:@"curpage"];
        [self.handleredResult setObject:totalNumber forKey:@"totalnum"];
        [self.handleredResult setObject:totalPage forKey:@"totalpage"];
    }
}
@end
