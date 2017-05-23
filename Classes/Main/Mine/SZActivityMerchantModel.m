//
//  SZActivityMerchantModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZActivityMerchantModel.h"

@implementation SZActivityMerchantModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_id",@"store_id",
            @"pic_url",@"pic_url",
            @"store_name",@"store_name",
            @"supply_card",@"supply_card",
            @"store_score",@"store_score",
            @"capita",@"capita",
            @"address",@"address",
            @"lng",@"lng",
            @"lat",@"lat",
            @"distance",@"distance",
            @"is_pic",@"is_pic",
            @"show_url",@"show_url",
            nil];
}

@end
