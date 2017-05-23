//
//  SZGoodsDetailRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZGoodsDetailRequest.h"
#import "SZPreferentialModel.h"
#import "SZStoreModel.h"
#import "SZGoodsNameModel.h"

@implementation SZGoodsDetailRequest

- (void)processResult
{
    [super processResult];
//    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"dataDict fuck is %@",dataDict);
        NSDictionary *goodsinfo = [dataDict objectForKey:@"goodsinfo"];
        NSDictionary *storeinfo = [dataDict objectForKey:@"storeinfo"];
        SZPreferentialModel *preferentialModel = [[SZPreferentialModel alloc] initWithDataDic:goodsinfo];
        [self.handleredResult setObject:preferentialModel forKey:@"preferentialModel"];
        NSArray *goods_name = [goodsinfo objectForKey:@"goods_name"];
        if(goods_name && [goods_name isKindOfClass:[NSArray class]] && [goods_name count] == 5){
//            NSLog(@"goods_name are %@",goods_name);
            SZGoodsNameModel *nameModel = [[SZGoodsNameModel alloc] init];
            nameModel.first = [goods_name objectAtIndex:0];
            nameModel.second = [goods_name objectAtIndex:1];
            nameModel.third = [goods_name objectAtIndex:2];
            nameModel.forth = [goods_name objectAtIndex:3];
            nameModel.fifth = [goods_name objectAtIndex:4];
            preferentialModel.goods_name = nameModel;
        }
        SZStoreModel *storeModel = [[SZStoreModel alloc] initWithDataDic:storeinfo];
        [self.handleredResult setObject:storeModel forKey:@"storeModel"];
        
        NSString *state = [storeinfo objectForKey:@"state"];
        [self.handleredResult setObject:state forKey:@"state"];
        
    }
}

@end
