
//
//  SZNearByGetCommentRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByGetCommentRequest.h"
#import "SZNearByUserCommentModel.h"
#import "IdentifierValidator.h"
@implementation SZNearByGetCommentRequest
- (void)processResult
{
    NSString * list = @"list";
    NSString * curpage = @"curpage";
    NSString * pagesize = @"pagesize";
    NSString * totalnum = @"totalnum";
    NSString * totalpage = @"totalpage";
    [super processResult];
    if (self.result.isSuccess) {
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        NSMutableArray *commentArray = [NSMutableArray array];
        if ([[dataDict objectForKey:list]isKindOfClass:[NSArray class]]&&[[dataDict objectForKey:list]count]!=0) {
            for (NSDictionary *dic in [dataDict objectForKey:list]) {
                SZNearByUserCommentModel *model = [[SZNearByUserCommentModel alloc]initWithDataDic:dic];
                if ([model.anonymous integerValue]==1) {
                    model.user_name = @"泰优惠用户";
                }
                if ([IdentifierValidator isValid:IdentifierTypePhone value:model.user_name]) {
                    NSRange range = {3,4};
                    NSString *star = @"****";
                    model.user_name = [model.user_name stringByReplacingCharactersInRange:range withString:star];
                }
                [commentArray addObject:model];
            }
        }
        NSString *currentPage = [NSString stringWithFormat:@"%@",[dataDict objectForKey:curpage]];
        NSString *totalPage = [NSString stringWithFormat:@"%@",[dataDict objectForKey:totalpage]];
        NSString *totalNumber = [NSString stringWithFormat:@"%@",[dataDict objectForKey:totalnum]];
        NSString *pagesizes = [NSString stringWithFormat:@"%@",[dataDict objectForKey:pagesize]];
        [self.handleredResult setObject:commentArray forKey:NETDATA];
        [self.handleredResult setObject:currentPage forKey:@"curpage"];
        [self.handleredResult setObject:totalNumber forKey:@"totalnum"];
        [self.handleredResult setObject:totalPage forKey:@"totalpage"];
        [self.handleredResult setObject:pagesizes forKey:pagesize];
    }
}
@end
