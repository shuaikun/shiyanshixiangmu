//
//  SMAttendAuditingLeaveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-8.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditingLeaveRequest.h"

@implementation SMAttendAuditingLeaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/App_leave_auditing.do"];
    return urlString;
}
@end
