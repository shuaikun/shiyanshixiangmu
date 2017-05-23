//
//  SMAttendSaveTxRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendSaveTxRequest.h"

@implementation SMAttendSaveTxRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_recess_saveUpdate.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
