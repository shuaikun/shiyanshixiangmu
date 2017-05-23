//
//  SZUserFriendsModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserFriendsModel.h"

@implementation SZUserFriendsModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"real_name",@"real_name",
            @"portrait",@"portrait",
            @"mobile",@"mobile",
            @"user_id",@"user_id",
            @"first_letter",@"first_letter",
            nil];
}

- (id)initWithRealName:(NSString *)realName FirstLetter:(NSString *)firstLetter
{
    if(self = [super init]){
        _real_name = realName;
        _first_letter = firstLetter;
    }
    return self;
}

@end
