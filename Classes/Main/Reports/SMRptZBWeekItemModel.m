//
//  SMRptZBItemModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBWeekItemModel.h"

@implementation SMRptZBWeekItemModel

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"status", @"status",
            @"issue", @"issue",
            @"measures", @"measures",
            @"timenode", @"timenode",
            @"punishment", @"punishment",
            @"improveremark", @"improveremark",
            @"improvestatus", @"improvestatus",
            @"solvemeasure", @"solvemeasure",
            @"id", @"id",
            @"level", @"level",
            @"reason", @"reason",
            @"remark", @"remark",
            @"workcontent", @"workcontent",
            @"leadspeak", @"leadspeak",
            @"improvenode", @"improvenode",
            @"improvemeasures", @"improvemeasures",
            @"promise", @"promise",
            nil];
}


@end
