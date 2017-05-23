//
//  SZMerchantDetailModel.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZNearByAbsoluteStoreModel.h"
#import "SZNearByUserCommentModel.h"
#import "SZNearByAroundStoreModel.h"
#import "SZNearByProductPicModel.h"
#import "SZNearByFocusPicModel.h"
@interface SZNearByMerchantDetailModel : NSObject
@property (nonatomic, copy)   NSString *goods_totleNumber;
@property (nonatomic, copy)   NSString *comment_totleNumber;
@property (nonatomic, copy)   NSString *productPic_totleNumber;
@property (nonatomic, strong) SZNearByAbsoluteStoreModel*store;
@property (nonatomic, strong) SZNearByUserCommentModel *comment;
@property (nonatomic, strong) NSMutableArray *goods;
@property (nonatomic, strong) NSMutableArray *aroundShops;
@property (nonatomic, strong) NSMutableArray *focusPics;
@property (nonatomic, strong) NSMutableArray *productPics;
@end
