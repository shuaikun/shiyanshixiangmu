//
//  SMReportZBEditViewController.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SMOnButtonCell.h"
#import "SMRptZBModel.h"

@interface SMReportZBEditViewController : SZBaseViewController<SMOnButtonCellDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

-(void)setReportData:(SMRptZBModel*)model;


@end
