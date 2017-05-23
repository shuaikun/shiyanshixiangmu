//
//  SMAttendRemoveRegRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-28.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendRemoveRegRequest.h"

@implementation SMAttendRemoveRegRequest
- (NSString*)getRequestUrl
{ 
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_register_remove.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
