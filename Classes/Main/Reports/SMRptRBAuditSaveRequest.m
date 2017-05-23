//
//  SMRptRBAuditSaveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-11.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBAuditSaveRequest.h"

@implementation SMRptRBAuditSaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/lead_View/App_dailyleadspeak_save.do"];
    return urlString;
}
@end
