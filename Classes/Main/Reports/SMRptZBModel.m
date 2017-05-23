//
//  SMRptZBModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBModel.h"

@implementation SMRptZBModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",      @"id",
            @"ywc",      @"ywc",
            @"nextWeeklys",      @"nextWeeklys",
            @"weeklys",      @"weeklys",
            @"submitstatus",      @"submitstatus",
            @"submitdate",      @"submitdate",
            @"zt",      @"zt",
            
            @"ldpf",      @"ldpf",
            @"jxgj",      @"jxgj",
            @"date",      @"date",
            @"wwc",      @"wwc",
            @"month",      @"month",
            @"year",      @"year",
            @"week",      @"week",
            nil];
}


@end
