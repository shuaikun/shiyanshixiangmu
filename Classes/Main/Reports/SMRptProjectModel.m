//
//  SMRptProjectModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptProjectModel.h"

@implementation SMRptProjectModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",      @"id",
            @"status",      @"status",
            @"principal",      @"principal",
            @"createTime",      @"createTime",
            @"budgetsum",      @"budgetsum",
            @"isnocontract",      @"isnocontract",
            @"jcompanyname",      @"jcompanyname",
            @"jcontacts",      @"jcontacts",
            @"order_id",      @"order_id",
            @"phone",      @"phone",
            @"predictendtime",      @"predictendtime",
            @"predictstarttime",      @"predictstarttime",
            @"projectcode",      @"projectcode",
            @"projectname",      @"projectname",
            @"projecttype",      @"projecttype",
            @"stylistname",      @"stylistname",
            @"updateTime",      @"updateName",
            @"updateName",      @"updateName",
            nil];
}
@end
