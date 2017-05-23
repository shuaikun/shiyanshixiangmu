//
//  SMRptRBRemoveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-3.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBRemoveRequest.h"

@implementation SMRptRBRemoveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"command/worklog_View/App_worklog_remove.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
