//
//  SMRptZBAuditPlanListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-15.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditPlanListRequest.h"

@implementation SMRptZBAuditPlanListRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/app_querylogclass_list.do"];
    return urlString;
}

@end
