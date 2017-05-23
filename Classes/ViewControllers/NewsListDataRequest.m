//
//  NewsListDataRequest.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/16/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "NewsListDataRequest.h"
#import "AQCNews.h"

#define TEST_REQUEST_DOMAIN @"http://202.108.35.176"
@implementation NewsListDataRequest


- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (NSString*)getRequestUrl
{
    return [NSString stringWithFormat:@"%@%@", [self getRequestHost], @"/interface/get_new_list_by_type_autosina_focus_json.php?"];
}

- (void)processResult
{
    [super processResult];
    if (![self isSuccess]) {
        ITTDERROR(@"request[%@] failed with message %@",self,self.result.code);
    }
    else {
        NSArray *dataArray = (self.handleredResult)[@"data"];
        if (dataArray && [dataArray count] > 0) {
            NSMutableArray *newsList = [NSMutableArray array];
            for (NSDictionary *newsDataDic in dataArray) {
                AQCNews *news = [[AQCNews alloc] initWithDataDic:newsDataDic];
                [newsList addObject:news];
            }
            (self.handleredResult)[@"newsList"] = newsList;
            [self.handleredResult removeObjectForKey:@"data"];
        }
        ITTDINFO(@"processed result:%@",self.handleredResult);
    }
}
@end
