//
//  SZNearByMerchantDetailRequest.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByMerchantDetailRequest.h"
#import "SZNearByMerchantDetailModel.h"
#import "SZNearByFocusPicModel.h"
#import "SZNearByGoodModel.h"
#import "NSString+ITTAdditions.h"
#import "IdentifierValidator.h"

NSString *focus_list = @"focus_list";
NSString *store_list = @"store_list";
NSString *goods_list = @"goods_list";
NSString *product_pic_list = @"product_pic_list";
NSString *comment_list = @"comment_list";
NSString *around_list = @"around_list";

@implementation SZNearByMerchantDetailRequest
- (void)processResult
{
    [super processResult];
    NSLog(@"the hurry push result = %@",self.handleredResult);
    if (self.result.isSuccess) {
        
        NSDictionary *dataDict = [self.handleredResult objectForKey:NETDATA];
        SZNearByMerchantDetailModel *detailModel = [SZNearByMerchantDetailModel new];
        
        detailModel.productPic_totleNumber = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"product_pic_totalnum"]];
        detailModel.comment_totleNumber = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"comment_totalnum"]];
        detailModel.goods_totleNumber = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"goods_totalnum"]];
        
        if ([[dataDict objectForKey:comment_list]isKindOfClass:[NSArray class]]&&[[dataDict objectForKey:comment_list]count]!=0) {
            detailModel.comment = [[SZNearByUserCommentModel alloc]initWithDataDic:[[dataDict objectForKey:comment_list] objectAtIndex:0]];
            if ([IdentifierValidator isValid:IdentifierTypePhone value:detailModel.comment.user_name]) {
                NSRange range = {3,4};
                NSString *star = @"****";
                detailModel.comment.user_name = [detailModel.comment.user_name stringByReplacingCharactersInRange:range withString:star];
            }
            if ([detailModel.comment.anonymous intValue]==1) {
                detailModel.comment.user_name = @"泰优惠用户";
            }
        }
        
        detailModel.store = [[SZNearByAbsoluteStoreModel alloc]initWithDataDic:[dataDict objectForKey:store_list]];

        if ([[dataDict objectForKey:focus_list]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dataDict objectForKey:focus_list]) {
                SZNearByFocusPicModel *focusPic = [[SZNearByFocusPicModel alloc]initWithDataDic:dic];
                [detailModel.focusPics addObject:focusPic];
            }
        }
        if ([[dataDict objectForKey:goods_list]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dataDict objectForKey:goods_list]) {
                SZNearByGoodModel *goods = [[SZNearByGoodModel alloc]initWithDataDic:dic];
                [detailModel.goods addObject:goods];
            }

        }
        
        if ([[dataDict objectForKey:product_pic_list]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dataDict objectForKey:product_pic_list]) {
                SZNearByProductPicModel *pic = [[SZNearByProductPicModel alloc]initWithDataDic:dic];
                pic.pic_url = [pic.pic_url stringFormatterWithStr:@"s"];
                [detailModel.productPics addObject:pic];
            }
        }
        
        if ([[dataDict objectForKey:around_list]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dataDict objectForKey:around_list]) {
                SZNearByAroundStoreModel *around = [[SZNearByAroundStoreModel alloc]initWithDataDic:dic];
                [detailModel.aroundShops addObject:around];
            }
        }
        
        [self.handleredResult setObject:detailModel forKey:NETDATA];
    }
}
@end
