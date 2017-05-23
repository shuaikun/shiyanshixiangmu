//
//  SMAttendAuditingBatchRegRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 2014-12-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditingBatchRegRequest.h"

@implementation SMAttendAuditingBatchRegRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/app_register_batch_auditing.do"];
    return urlString;
}
@end
