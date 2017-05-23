//
//  WWImagePostRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-28.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWImagePostRequest.h"

@implementation WWImagePostRequest
- (NSString*)getRequestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"user/fileupload.action"];
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://115.28.142.76/damai/index.php?route=api/", @"product/upload"];
    return urlString;
}
@end
