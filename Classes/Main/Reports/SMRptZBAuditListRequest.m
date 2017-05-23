//
//  SMRptZBAuditListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditListRequest.h"

@implementation SMRptZBAuditListRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/lead_View/App_leadweekly_list.do"];
    return urlString;
}

@end
