//
//  SMAttendMyRegListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-11.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendRegListRequest.h"

@implementation SMAttendRegListRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_register_list.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
