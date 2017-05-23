//
//  SMReportEditViewController.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SMRptRBModel.h"
#import "SMOnButtonCell.h"

@interface SMReportRBEditViewController : SZBaseViewController<SMOnButtonCellDelegate, UITextViewDelegate>

-(void)setReportData:(SMRptRBModel*)model;

@end
