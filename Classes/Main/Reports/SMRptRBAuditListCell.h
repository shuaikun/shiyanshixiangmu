//
//  SMRptRBAuditListCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptRBAuditListModel.h"

@interface SMRptRBAuditListCell : UITableViewCell
+ (SMRptRBAuditListCell *)cellFromNib;
-(void)setData:(SMRptRBAuditListModel*)model;
@end
