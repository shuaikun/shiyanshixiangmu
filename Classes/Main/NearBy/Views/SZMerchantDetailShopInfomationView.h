//
//  SZMerchantDetailShopInfomationView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SZMerchantDetailShopInfomationViewMapClick)(void);
@interface SZMerchantDetailShopInfomationView : UIView
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *addtion;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) SZMerchantDetailShopInfomationViewMapClick mapClick;
@end
