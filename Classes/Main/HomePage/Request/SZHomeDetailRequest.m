//
//  SZHomeDetailReuest.m
//  iTotemFramework
//
//  Created by Grant on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZHomeDetailRequest.h"
#import "SZActivityModel.h"
#import "SZCouponModel.h"

NSString *const SZHomeDetailRequestActivityList = @"activity_list";
NSString *const SZHomeDetailRequestGoodsList    = @"goods_list";

@implementation SZHomeDetailRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSMutableArray *activityArray = [NSMutableArray array];
        NSArray *activityListData = dataDict[SZHomeDetailRequestActivityList];
        if ([CommonUtils arrayContrainsObject:activityListData])
        {
            for (NSDictionary *activityData in activityListData) {
                SZActivityModel *activityModel = [[SZActivityModel alloc] initWithDataDic:activityData];
                [activityArray addObject:activityModel];
            }
        }

        
        NSMutableArray *preferentialArray = [NSMutableArray array];
        NSArray *preferentialListData = dataDict[SZHomeDetailRequestGoodsList];
        if ([CommonUtils arrayContrainsObject:preferentialListData])
        {
            for (NSDictionary *preferentialData in preferentialListData) {
                SZCouponModel * preferentialModel = [[SZCouponModel alloc] initWithDataDic:preferentialData];
                [preferentialArray addObject:preferentialModel];
                NSArray *goods_name = [preferentialData objectForKey:@"goods_name"];
                if(goods_name && [goods_name isKindOfClass:[NSArray class]] && [goods_name count] == 5){
                    NSLog(@"goods_name are %@",goods_name);
                    SZGoodsNameModel *nameModel = [[SZGoodsNameModel alloc] init];
                    nameModel.first = [goods_name objectAtIndex:0];
                    nameModel.second = [goods_name objectAtIndex:1];
                    nameModel.third = [goods_name objectAtIndex:2];
                    nameModel.forth = [goods_name objectAtIndex:3];
                    nameModel.fifth = [goods_name objectAtIndex:4];
                    preferentialModel.goods_name = nameModel;
                }
            }
        }
        
        NSMutableDictionary *parsedData = [dataDict mutableCopy];
        [parsedData setObject:activityArray forKey:SZHomeDetailRequestActivityList];
        [parsedData setObject:preferentialArray forKey:SZHomeDetailRequestGoodsList];
        [self.handleredResult setObject:parsedData forKey:NETDATA];
    }

}
@end
