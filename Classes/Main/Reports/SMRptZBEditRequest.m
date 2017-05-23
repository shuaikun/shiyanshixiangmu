//
//  SMRptZBEditRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-10.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBEditRequest.h"

@implementation SMRptZBEditRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_weekly_saveOrUpdate.do"];
    return urlString;
}

@end
