//
//  SMAttendRegModel.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendRegModel.h"

@implementation SMAttendRegModel 
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"reason",      @"reason",
            @"status",      @"status",
            @"oneperson",   @"oneperson",
            @"shenheTime",  @"shenheTime",
            @"oneopinion",  @"oneopinion",
            @"date",        @"date",
            @"id",          @"id",
            @"time",        @"time",
            @"submittime",  @"submittime",
            @"role",        @"role",
            @"staffid",     @"staffid",
            @"deptname",    @"deptname",
            @"onetime",     @"onetime",
            @"staffname",   @"staffname",
            @"updatetime",   @"updatetime",
            nil];
}


-(BOOL)canEdit
{
    
    if ( [self.status isEqualToString:@"暂存"]){
        return true;
    }
    else if (self.status.length == 0){
        return true;
    }
    
    
    return false;
}


@end
