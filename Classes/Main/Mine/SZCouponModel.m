
//
//  SZCouponModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCouponModel.h"

@implementation SZCouponModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_name",@"store_name",
            @"expire_start",@"expire_start",
            @"expire_end",@"expire_end",
            @"goods_id",@"goods_id",
            @"type",@"type",
            @"pic_url",@"pic_url",
            @"store_id",@"store_id",
            @"sales",@"sales",
            @"distance",@"distance",
            @"lng",@"lng",
            @"lat",@"lat",
            @"is_pic",@"is_pic",
            @"show_url",@"show_url",
            nil];
}

@end
