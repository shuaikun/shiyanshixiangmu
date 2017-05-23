//
//  SMRptProjectListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptProjectListRequest.h"

@implementation SMRptProjectListRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_project_list.do"];
    return urlString;
}
@end
