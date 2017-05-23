//
//  SZMerchantDetailAroundCellView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SZMerchantDetailAroundClick)(void);
@interface SZMerchantDetailAroundCellView : UIView
@property (nonatomic, copy) SZMerchantDetailAroundClick click;
@property (nonatomic, copy) NSString *text;
@end
