//
//  SZUserCommentRequest.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserCommentRequest.h"
#import "SZCommentModel.h"

@implementation SZUserCommentRequest

- (void)processResult
{
    [super processResult];
//    NSLog(@"the hurry push result = %@",self.handleredResult);
    if(self.result.isSuccess){
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSLog(@"dataDict haha is %@",dataDict);
        NSString *curpage = [dataDict objectForKey:@"curpage"];
        NSString *totalpage = [dataDict objectForKey:@"totalpage"];
        NSString *totalnum = [dataDict objectForKey:@"totalnum"];
        [self.handleredResult setObject:curpage forKey:@"curpage"];
        [self.handleredResult setObject:totalpage forKey:@"totalpage"];
        [self.handleredResult setObject:totalnum forKey:@"totalnum"];
        NSArray *comments_list = [dataDict objectForKey:@"list"];
        if(comments_list && [comments_list isKindOfClass:[NSArray class]]){
            NSMutableArray *listsArray = [NSMutableArray array];
            for(NSDictionary *dic in comments_list){
                SZCommentModel *model = [[SZCommentModel alloc] initWithDataDic:dic];
                [listsArray addObject:model];
            }
            [self.handleredResult setObject:listsArray forKey:@"comments_list"];
        }
    }
}

@end
