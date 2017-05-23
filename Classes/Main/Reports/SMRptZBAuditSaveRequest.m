//
//  SMRptZBAuditSaveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-15.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditSaveRequest.h"

@implementation SMRptZBAuditSaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/lead_View/App_weeklyleadspeak_save.do"];
    return urlString;
}

@end
