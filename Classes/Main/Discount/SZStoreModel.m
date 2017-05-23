//
//  SZStoreModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZStoreModel.h"

@implementation SZStoreModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_id",@"store_id",
            @"pic_url",@"pic_url",
            @"tel",@"tel",
            @"store_name",@"store_name",
            @"supply_card",@"supply_card",
            @"store_score",@"store_score",
            @"score",@"score",
            @"capita",@"capita",
            @"address",@"address",
            @"distance",@"distance",
            @"enter_type",@"enterType",
            nil];
}

@end
