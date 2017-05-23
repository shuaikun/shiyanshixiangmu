//
//  SMAttendLeaveModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendLeaveModel.h"

@implementation SMAttendLeaveModel
- (NSDictionary *)attributeMapDictionary
{
    return @{
             @"reason": @"reason",
             @"status": @"status",
             @"oneperson": @"oneperson",
             @"shenheTime": @"shenheTime",
             @"oneopinion": @"oneopinion",
             @"endTime": @"endTime",
             @"endtime": @"endtime",
             @"type": @"type",
             @"id": @"id",
             @"startTime": @"startTime",
             @"starttime": @"starttime",
             @"sumTime": @"sumTime",
             @"sumtime": @"sumtime",
             @"submittime":@"submittime",
             @"role":@"role",
             @"staffid":@"staffid",
             @"onetime":@"onetime",
             @"deptname":@"deptname",
             @"staffname":@"staffname",
             @"updatetime":@"updatetime",
             @"twoperson":@"twoperson",
             @"twoopinion":@"twoopinion",
             @"twotime":@"twotime",
        };
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
