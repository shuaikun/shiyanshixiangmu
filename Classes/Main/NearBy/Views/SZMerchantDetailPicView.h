//
//  SZMerchantDetailPicView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNearByProductPicModel.h"
typedef void(^SZMerchantDetailPicClick)(SZNearByProductPicModel *pic);
@interface SZMerchantDetailPicView : UIView
@property (nonatomic, strong) SZNearByProductPicModel *pic;
@property (nonatomic, copy) SZMerchantDetailPicClick click;
@end
