//
//  SZMoreVersionCheckRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-25.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMoreVersionCheckRequest.h"
#import "SZMoreVersionModel.h"
@implementation SZMoreVersionCheckRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if ([self.result isSuccess]) {
        NSDictionary *data = [self.handleredResult objectForKey:NETDATA];
        SZMoreVersionModel *version = [[SZMoreVersionModel alloc ]init];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [NSString stringWithFormat:@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        version.AppStoreVersion = [NSString stringWithFormat:@"%@",[data objectForKey:@"version"]];
        version.currentVersion = app_Version;
        if (![version.AppStoreVersion isEqualToString:version.currentVersion]) {
            version.haveNew = YES;
        }else{
            version.haveNew = NO;
        }
        version.currentVersion = [NSString stringWithFormat:@"当前版本: v%@",app_Version];
        version.downloadUrl = [data objectForKey:@"url"];
        [self.handleredResult setObject:version forKey:NETDATA];
    }
}
@end
