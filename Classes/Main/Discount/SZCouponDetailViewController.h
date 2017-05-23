//
//  SZCouponDetailViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SZPreferentialRelativeTopView.h"
@class SZCouponModel;
@interface SZCouponDetailViewController : SZBaseViewController<SZPreferentialRelativeTopViewDelegate>

@property (strong, nonatomic) SZPreferentialRelativeTopView * topView;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;
@property (nonatomic, strong) UIImage *shareImage;
@property (strong, nonatomic) SZCouponModel *couponModel;

@end
