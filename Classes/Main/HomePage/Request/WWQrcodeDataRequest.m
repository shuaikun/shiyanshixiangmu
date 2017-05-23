//
//  WWQrcodeDataRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-16.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWQrcodeDataRequest.h"
#import "WWQrcodeModel.h"

@implementation WWQrcodeDataRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"qrcode/data.action"];
    return urlString;
}

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
        NSMutableDictionary *dicData= [self.handleredResult objectForKey:NETDATA];
        WWQrcodeModel *qrcodeModel = [[WWQrcodeModel alloc] initWithDataDic:dicData];
        
        //list
        NSArray *listData = [self.handleredResult objectForKey:@"waste_data"];
        NSMutableArray *activityArray = [NSMutableArray array];
        if ([CommonUtils arrayContrainsObject:listData])
        {
            for (NSDictionary *activityData in listData) {
                WWQrcodeListItemModel *activityModel = [[WWQrcodeListItemModel alloc] initWithDataDic:activityData];
                [activityArray addObject:activityModel];
            }
        }
        qrcodeModel.list = [[NSMutableArray alloc] initWithArray:activityArray];
        
        [self.handleredResult setObject:qrcodeModel forKey:NETDATA];
    }
    
}
@end
