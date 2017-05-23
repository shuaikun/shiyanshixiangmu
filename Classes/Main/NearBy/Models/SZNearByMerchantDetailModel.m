//
//  SZMerchantDetailModel.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByMerchantDetailModel.h"
@implementation SZNearByMerchantDetailModel
- (id)init
{
    self = [super init];
    if (self) {
        self.store = [SZNearByAbsoluteStoreModel  new];
        self.goods = [NSMutableArray array];
        self.aroundShops = [NSMutableArray array];
        self.productPics = [NSMutableArray array];
        self.focusPics = [NSMutableArray array];
    }
    return self;
}
@end
