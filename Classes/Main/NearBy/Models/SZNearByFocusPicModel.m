//
//  SZNearByFocusPicModel.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByFocusPicModel.h"
@implementation SZNearByFocusPicModel
@synthesize pic_url = _pic_url;
@synthesize img_id = _img_id;
@synthesize title = _title;
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"img_id",@"img_id",
            @"pic_url",@"pic_url",
            @"title",@"title",nil];
}
@end
