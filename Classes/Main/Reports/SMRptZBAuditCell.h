//
//  SMRptZBAuditCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBAuditModel.h"

@interface SMRptZBAuditCell : UITableViewCell
+ (SMRptZBAuditCell *)cellFromNib;
-(void)setData:(SMRptZBAuditModel*)model;
@end
