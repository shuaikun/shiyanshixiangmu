//
//  SMRptZBNextweekItemModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBNextweekItemModel.h"

@implementation SMRptZBNextweekItemModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        @"person", @"person",
        @"measures", @"measures",
        @"timenode", @"timenode",
        @"punishment", @"punishment",
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
