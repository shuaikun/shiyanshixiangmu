//
//  SZUserHistoryRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserHistoryRequest.h"
#import "SZActivityMerchantModel.h"
#import "SZCouponModel.h"

@implementation SZUserHistoryRequest

- (void)processResult
{
    [super processResult];
//    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
//        NSLog(@"dataDict is %@",dataDict);
        NSString *curpage = [dataDict objectForKey:@"curpage"];
        NSString *totalpage = [dataDict objectForKey:@"totalpage"];
        NSString *totalnum = [dataDict objectForKey:@"totalnum"];
        [self.handleredResult setObject:curpage forKey:@"curpage"];
        [self.handleredResult setObject:totalpage forKey:@"totalpage"];
        [self.handleredResult setObject:totalnum forKey:@"totalnum"];
        //
        NSArray *goods_list = [dataDict objectForKey:@"goods_list"];
        if(goods_list && [goods_list isKindOfClass:[NSArray class]]){
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in goods_list){
                SZCouponModel *model = [[SZCouponModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
                NSArray *goods_name = [dic objectForKey:@"goods_name"];
                if(goods_name && [goods_name isKindOfClass:[NSArray class]] && [goods_name count] == 5){
                    NSLog(@"goods_name are %@",goods_name);
                    SZGoodsNameModel *nameModel = [[SZGoodsNameModel alloc] init];
                    nameModel.first = [goods_name objectAtIndex:0];
                    nameModel.second = [goods_name objectAtIndex:1];
                    nameModel.third = [goods_name objectAtIndex:2];
                    nameModel.forth = [goods_name objectAtIndex:3];
                    nameModel.fifth = [goods_name objectAtIndex:4];
                    model.goods_name = nameModel;
                }
            }
            [self.handleredResult setObject:listsArray forKey:@"goods_list"];
        }
        //
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
