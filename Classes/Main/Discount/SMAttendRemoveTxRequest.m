//
//  SMAttendRemoveTxRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-28.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendRemoveTxRequest.h"

@implementation SMAttendRemoveTxRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_recess_remove.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
