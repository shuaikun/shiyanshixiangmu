//
//  SZUserCenterModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserCenterModel.h"

@implementation SZUserCenterModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"goods_sum",@"goods_sum",
            @"cards_sum",@"cards_sum",
            @"collects_sum",@"collects_sum",
            @"friends_sum",@"friends_sum",
            @"comments_sum",@"comments_sum",
            @"friends_dyn_sum",@"friends_dyn_sum",
            @"newrecord",@"newrecord",
            nil];
}

@end
