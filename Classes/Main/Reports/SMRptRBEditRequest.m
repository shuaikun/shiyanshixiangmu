//
//  SMRptRBEditRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-3.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBEditRequest.h"

@implementation SMRptRBEditRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_worklog_saveOrUpdate.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
