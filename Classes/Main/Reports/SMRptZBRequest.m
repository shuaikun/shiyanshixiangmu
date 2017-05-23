//
//  SMRptZBRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBRequest.h"

@implementation SMRptZBRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_weekly_list.do"];
    return urlString;
}
@end
