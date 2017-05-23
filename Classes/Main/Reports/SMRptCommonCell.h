//
//  SMRptCommonCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptRBModel.h"

@interface SMRptCommonCell : UITableViewCell
+ (SMRptCommonCell *)cellFromNib;
-(void)setData:(SMRptRBModel*)model;
@end
