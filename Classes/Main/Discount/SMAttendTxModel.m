//
//  SMAttendTxModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendTxModel.h"

@implementation SMAttendTxModel
- (NSDictionary *)attributeMapDictionary
{
    return @{
             @"reason": @"reason",
             @"restDate": @"restDate",
             @"applydate": @"applydate",
             @"extraworkDate": @"extraworkDate",
             @"extraworkTime": @"extraworkTime",
             @"status": @"status",
             @"remark": @"remark",
             @"peroson": @"peroson",
             @"auditingdate": @"auditingdate",
             @"id": @"id",
             @"extrawork": @"extrawork",
             @"staffName": @"staffName",
             @"opinion": @"opinion",
             @"restTime": @"restTime",
             @"rest": @"rest",
             @"updatetime": @"updatetime"
             };
}


-(BOOL)canEdit
{
    
    if ( [self.status isEqualToString:@"0"]){
        return true;
    }
    else if (self.status.length == 0){
        return true;
    }
    
    return false;
}

@end
