//
//  SMAttendAuditTxRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditTxRequest.h"

@implementation SMAttendAuditTxRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_shenhe/App_recess_auditing_save.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
