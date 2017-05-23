//
//  WWWasteTypeRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWWasteTypeRequest.h"
#import "WWWasteTypeModel.h"

@implementation WWWasteTypeRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"common/wastetype.action"];
    return urlString;
}

- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess)
    {
        NSArray *datalist = [self.handleredResult objectForKey:@"list"];
        NSMutableArray *activityArray = [NSMutableArray array];
        if ([CommonUtils arrayContrainsObject:datalist])
        {
            for (NSDictionary *itemData in datalist) {
                WWWasteTypeModel *activityModel = [[WWWasteTypeModel alloc] initWithDataDic:itemData];
                [activityArray addObject:activityModel];
            }
        }
        
        [self.handleredResult setObject:activityArray forKey:NETDATA];
    }
    
}
@end
