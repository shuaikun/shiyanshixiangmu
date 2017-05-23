//
//  SMNewsDetailModel.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-5.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsDetailModel.h"

@implementation SMNewsDetailModel
- (NSDictionary*)attributeMapDictionary
{
	return @{@"need_regenerate"    : @"need_regenerate",
             @"media_type"    : @"media_type",
             @"link"    : @"link",
             @"origin"    : @"origin",
             @"tpl_content"    : @"tpl_content",
             @"txt"    : @"txt",
             @"is_bold"    : @"is_bold",
             @"txt1"    : @"txt1",
             @"short_title"    : @"short_title",
             @"author"    : @"author",
             @"txt2"    : @"txt2",
             @"title"    : @"title",
             @"txt3"    : @"txt3",
             @"content_id"    : @"content_id",
             @"origin_url"    : @"origin_url",
             @"description"    : @"description",
             @"title_img"    : @"title_img",
             @"type_img"    : @"type_img",
             @"release_date"    : @"release_date",
             @"media_path"    : @"media_path",
             @"title_color"    : @"title_color",
             @"content_img"    : @"content_img",
             };
}
@end
