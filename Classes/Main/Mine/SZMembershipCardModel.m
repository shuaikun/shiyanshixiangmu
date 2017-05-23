//
//  SZMembershipCardModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMembershipCardModel.h"

@implementation SZMembershipCardModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_name",@"store_name",
            @"goods_id",@"goods_id",
            @"type",@"type",
            @"pic_url",@"pic_url",
            @"is_pic",@"is_pic",
            @"show_url",@"show_url",
            @"code",@"code",
            nil];
}

@end
