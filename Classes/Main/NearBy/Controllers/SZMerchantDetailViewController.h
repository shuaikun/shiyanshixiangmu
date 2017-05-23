//
//  SZMerchantDetailViewController.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SZNearByMerchantDetailRequestModel.h"
@interface SZMerchantDetailViewController : SZBaseViewController
@property (nonatomic, strong) SZNearByMerchantDetailRequestModel *requestModel;
@property (nonatomic, strong) UIImage *shareImage;
@end
