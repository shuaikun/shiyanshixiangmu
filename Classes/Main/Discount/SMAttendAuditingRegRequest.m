//
//  SMAttendAuditingRegRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-8.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditingRegRequest.h"

@implementation SMAttendAuditingRegRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/App_register_auditing.do"];
    return urlString;
}
@end
