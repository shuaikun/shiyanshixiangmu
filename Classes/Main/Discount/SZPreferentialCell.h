//
//  SZPreferentialCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCouponModel.h"

@interface SZPreferentialCell : UITableViewCell

@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL fromHistory;

+ (SZPreferentialCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZCouponModel *)model;



@end
