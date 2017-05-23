//
//  SMAttendAuditingBatchLeaveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 2014-12-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditingBatchLeaveRequest.h"

@implementation SMAttendAuditingBatchLeaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/app_Leave_batch_auditing.do"];
    return urlString;
}
@end
