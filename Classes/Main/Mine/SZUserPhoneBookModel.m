//
//  SZUserPhoneBookModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserPhoneBookModel.h"

@implementation SZUserPhoneBookModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"friend_name",@"friend_name",
            @"friend_mobile",@"friend_mobile",
            @"type",@"type",
            @"user_id",@"user_id",
            @"portrait",@"portrait",
            nil];
}

@end
