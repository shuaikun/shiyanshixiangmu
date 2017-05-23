//
//  SMAttendLeaveListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-11.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendLeaveListRequest.h"

@implementation SMAttendLeaveListRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_leave_list.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end