//
//  SMRptYBRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-11.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptYBRequest.h"

@implementation SMRptYBRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_weekly_list是.do"];
    return urlString;
}
@end
