//
//  SZUserInfoModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserInfoModel.h"

@implementation SZUserInfoModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"gender",@"gender",
            @"portrait",@"portrait",
            @"real_name",@"real_name",
            nil];
}

@end
