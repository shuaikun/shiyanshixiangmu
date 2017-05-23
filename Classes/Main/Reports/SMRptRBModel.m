//
//  SMRptRBModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBModel.h"

@implementation SMRptRBModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",      @"id",
            @"tommemo",      @"tommemo",
            @"ywc",   @"ywc",
            @"dailys",  @"dailys",
            @"submitstatus",  @"submitstatus",
            @"submitdate",        @"submitdate",
            @"zt", @"zt",
            @"summarize",@"summarize",
            @"ldpf",@"ldpf",
            @"jxgj",@"jxgj",
            @"date",@"date",
            @"wwc",@"wwc",
            nil];
}

@end
