//
//  SMRptZBWeekItemCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBWeekItemModel.h"

@interface SMRptZBWeekItemCell : UITableViewCell
+ (SMRptZBWeekItemCell *)cellFromNib;
-(void)setData:(SMRptZBWeekItemModel*)model;
@end
