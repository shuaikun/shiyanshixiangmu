//
//  SMRptZBNextWeekItemPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-10.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBNextweekItemModel.h"

@interface SMRptZBNextWeekItemPickView : UIView<UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
- (void)showReportZBNextWeekItemPickViewWithFinishBlock:(void(^)(SMRptZBNextweekItemModel *model, int optype, NSString *opinion))finishBlock;
-(void)setData:(SMRptZBNextweekItemModel*) model;
@end
