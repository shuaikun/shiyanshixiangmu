//
//  SZMerchantDiscountView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"
#import "SZNearByGoodModel.h"
typedef void (^SZMerchantDiscountViewCallBack)(float offSet, BOOL show);
typedef void (^SZMerchantDiscountViewCellClickCallBack)(SZNearByGoodModel *good);
@interface SZMerchantDiscountView : ITTXibView
@property (nonatomic, copy) SZMerchantDiscountViewCallBack callBack;
@property (nonatomic, copy) SZMerchantDiscountViewCellClickCallBack clickCallBack;

- (id)initWithFrame:(CGRect)frame discounts:(NSMutableArray *)goods;


@end
