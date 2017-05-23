//
//  SMAttendSaveLeaveRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-21.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendSaveLeaveRequest.h"

@implementation SMAttendSaveLeaveRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_leave_save.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

@end
