//
//  SZPreferentialModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZPreferentialModel.h"

@implementation SZPreferentialModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"goods_id",@"goods_id",
            @"type",@"type",
            @"pic_url",@"pic_url",
            @"description",@"descrip",
            @"time_limit",@"time_limit",
            @"stock",@"stock",
            @"sales",@"sales",
            @"button",@"button",
            @"expire_start",@"expire_start",
            @"expire_end",@"expire_end",
            @"code",@"code",
            @"is_pic",@"is_pic",
            @"show_url",@"show_url",
            nil];
}

@end
