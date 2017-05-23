//
//  SZRegistRequest.m
//  iTotemFramework
//
//  Created by Grant on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZRegistRequest.h"

@implementation SZRegistRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"user/regUser.action"];
    return urlString;
}

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
        NSMutableDictionary *userDicData= [self.handleredResult objectForKey:@"user"];
        NSMutableDictionary *orgDicData= [self.handleredResult objectForKey:@"org"];
        
        NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
        [datas setObject:[userDicData objectForKey:@"id"] forKey:@"id"];
        [datas setObject:[userDicData objectForKey:@"phone"] forKey:@"phone"];
        [datas setObject:[userDicData objectForKey:@"userName"] forKey:@"userName"];
        [datas setObject:[orgDicData objectForKey:@"depCode"] forKey:@"depCode"];
        [datas setObject:[orgDicData objectForKey:@"depName"] forKey:@"depName"];
        [datas setObject:[orgDicData objectForKey:@"orgCode"] forKey:@"orgCode"];
        [datas setObject:[orgDicData objectForKey:@"orgName"] forKey:@"orgName"];
        [datas setObject:[orgDicData objectForKey:@"groupType"] forKey:@"groupType"];
        [datas setObject:[orgDicData objectForKey:@"contact"] forKey:@"contact"];
        
        //[[UserManager sharedUserManager] storeUserInfoWithGroupCode:orgDicData[@"depCode"]];
        //[[UserManager sharedUserManager] storeUserInfoWithGroupName:orgDicData[@"depName"]];
        
        [self.handleredResult setObject:datas forKey:NETDATA];
    }
}

@end
