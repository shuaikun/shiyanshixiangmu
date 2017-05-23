//
//  SMRptZBRemoveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-11.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBRemoveRequest.h"

@implementation SMRptZBRemoveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_worklog_remove.do"];
    return urlString;
}

@end
