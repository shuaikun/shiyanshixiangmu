//
//  SZUserCommentModel.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByUserCommentModel.h"

@implementation SZNearByUserCommentModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"comment_id",@"comment_id",
            @"user_id",@"user_id",
            @"user_name",@"user_name",
            @"uavatar",@"uavatar",
            @"comment",@"comment",
            @"score",@"score",
            @"add_time",@"add_time",
            @"anonymous",@"anonymous",
            nil];
}
@end
