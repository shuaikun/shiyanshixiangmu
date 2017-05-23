//
//  SZAbsoluteStoreModel.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByAbsoluteStoreModel.h"

@implementation SZNearByAbsoluteStoreModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_id",@"store_id",
            @"store_name",@"store_name",
            @"address",@"address",
            @"tel",@"tel",
            @"score",@"score",
            @"supply_card",@"supply_card",
            @"is_collected",@"is_collected",
            @"open_time",@"open_time",
            @"description",@"description",
            @"capita",@"capita",
            @"distance",@"distance",
            @"lat",@"lat",
            @"lng",@"lng",
            @"state",@"state",
            @"enter_type",@"enterType",
            nil];
}
@end
