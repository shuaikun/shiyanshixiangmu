//
//  SZHomeGoodsModel.m
//  iTotemFramework
//
//  Created by Grant on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZHomeGoodsModel.h"

@implementation SZHomeGoodsModel
- (NSDictionary*)attributeMapDictionary
{
	return @{@"distance" : @"distance"
             ,@"goodsId"   : @"goods_id"
             ,@"goodsName" : @"goods_name"
             ,@"picUrl" : @"pic_url"
             ,@"sales" : @"sales"
             ,@"storeName" : @"store_name"
             ,@"type" : @"type"
             };
}
@end
