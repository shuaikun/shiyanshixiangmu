//
//  SZCommentModel.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCommentModel.h"

@implementation SZCommentModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"aa_id",@"aa_id",
            @"store_id",@"store_id",
            @"store_name",@"store_name",
            @"user_name",@"user_name",
            @"comment",@"comment",
            @"score",@"score",
            @"add_time",@"add_time",
            nil];
}

- (id)initWithComment:(NSString *)comment
{
    if(self = [super init]){
        _comment = comment;
    }
    return self;
}

@end
