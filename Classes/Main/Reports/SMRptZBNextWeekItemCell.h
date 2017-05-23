//
//  SMRptZBNextWeekItemCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBNextweekItemModel.h"

@interface SMRptZBNextWeekItemCell : UITableViewCell
+ (SMRptZBNextWeekItemCell *)cellFromNib;
-(void)setData:(SMRptZBNextweekItemModel*)model;
@end
