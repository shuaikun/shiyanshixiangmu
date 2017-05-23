//
//  SMAttendanceLeaveRequest.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-6.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditLeaveRequest.h"

@implementation SMAttendAuditLeaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/App_leave_auditing_list.do"];
    return urlString;
}
@end
