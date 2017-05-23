//
//  SMRptRBItemCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptRBItemModel.h"

@interface SMRptRBItemCell : UITableViewCell
+ (SMRptRBItemCell *)cellFromNib;
-(void)setData:(SMRptRBItemModel*)model;
@end
