//
//  SZUserCenterRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserCenterRequest.h"
#import "WWQrcodeModel.h"

@implementation SZUserCenterRequest

- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"package/wasteused.action"];
    return urlString;
}

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        
        NSArray *packageList =[self.handleredResult objectForKey:NETDATA];
        
        //NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        //NSLog(@"dataDict is %@",dataDict);
        //WWQrcodeModel *model = [[WWQrcodeModel alloc] initWithDataDic:dataDict];
        
        [self.handleredResult setObject:[self array:packageList] forKey:@"model"];
    }
}

- (NSArray *)array:(id)packageList {

    if ([packageList isEqual:[NSNull null]]) {
        return @[];
    }
    if (packageList == nil) {
        return @[];
    }
    return packageList;
}

@end
