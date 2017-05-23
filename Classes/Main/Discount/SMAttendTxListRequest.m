//
//  SMAttendTxListRequest.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendTxListRequest.h"

@implementation SMAttendTxListRequest
- (NSString*)getRequestUrl
{
    //
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"kaoqin/my_apply/App_recess_list.do"];
    return urlString;
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
