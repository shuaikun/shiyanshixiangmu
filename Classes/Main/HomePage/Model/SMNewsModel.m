//
//  SMNewsModel.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-5.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsModel.h"

@implementation SMNewsModel
- (NSDictionary*)attributeMapDictionary
{
	return @{@"author"    : @"author"
             ,@"title"    : @"title"
             ,@"content_id"   : @"content_id"
             ,@"desc"  : @"desc"
             ,@"release_date"   : @"release_date"
             };
}
@end
