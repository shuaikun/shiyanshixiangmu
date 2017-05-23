//
//  SZNearByAroundStoreModel.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByAroundStoreModel.h"

@implementation SZNearByAroundStoreModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"store_id",@"store_id",
            @"store_name",@"store_name",
            @"distance",@"distance",
            @"lng",@"lng",
            @"lat",@"lat", nil];
}
@end
