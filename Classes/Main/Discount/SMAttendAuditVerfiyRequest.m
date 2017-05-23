//
//  SMAttendAuditVerfiy.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-10-15.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditVerfiyRequest.h"

@implementation SMAttendAuditVerfiyRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"platform/executeEngineApp.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
