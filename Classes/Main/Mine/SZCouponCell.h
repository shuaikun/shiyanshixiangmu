//
//  SZCouponCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCouponModel.h"

@protocol SZCouponCellDelegate <NSObject>
- (void)couponCellFinishDeleteIndex:(int)index IfValid:(BOOL)ifValid;
@end

@interface SZCouponCell : UITableViewCell

@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL ifValid;
@property (assign, nonatomic) id<SZCouponCellDelegate>delegate;

+ (SZCouponCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZCouponModel *)model;


@end
