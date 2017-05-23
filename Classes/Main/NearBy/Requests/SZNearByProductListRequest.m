//
//  SZNearByProductListRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-23.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByProductListRequest.h"
#import "SZNearByProductPicModel.h"


@implementation SZNearByProductListRequest
- (void)processResult
{
    NSString *const totalnum = @"totalnum";
    NSString *const totalpage = @"totalpage";
    NSString *const curpage = @"curpage";
    NSString *const pagesize = @"pagesize";
    NSString *const product_pic_list = @"product_pic_list";
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.isSuccess) {
        NSDictionary *dictionData = [self.handleredResult objectForKey:NETDATA];
        
        NSMutableArray *list = [[NSMutableArray alloc]init];
        NSArray *pics = [dictionData objectForKey:product_pic_list];
        if ([pics isKindOfClass:[NSArray class]]&&[pics count]!=0) {
            for (int i = 0; i<[pics count]; i++) {
                if ([[pics objectAtIndex:i]isKindOfClass:[NSDictionary class]]) {
                    SZNearByProductPicModel *pic = [[SZNearByProductPicModel alloc]initWithDataDic:[pics objectAtIndex:i]];
                    
                    pic.pic_url = [pic.pic_url stringFormatterWithStr:@"s"];
                    
                    [list addObject:pic];
                }
            }
        }
        [self.handleredResult setObject:list forKey:NETDATA];
        [self.handleredResult setObject:[dictionData objectForKey:totalnum] forKey:totalnum];
        [self.handleredResult setObject:[dictionData objectForKey:totalpage] forKey:totalpage];
        [self.handleredResult setObject:[dictionData objectForKey:curpage] forKey:curpage];
        [self.handleredResult setObject:[dictionData objectForKey:pagesize] forKey:pagesize];
    }
}
@end
