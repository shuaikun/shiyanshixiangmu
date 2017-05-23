//
//  SZMerchantDetailAroundView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SZMerchantDetailAroundViewClick)(NSString *storeId);
@interface SZMerchantDetailAroundView : UIView
@property (nonatomic, copy) SZMerchantDetailAroundViewClick click;
- (id)initWithFrame:(CGRect)frame aroundShops:(NSMutableArray *)shops;
@end
