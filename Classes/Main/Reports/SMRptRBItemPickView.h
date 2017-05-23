//
//  SMRptRBItemPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptRBItemModel.h"

@interface SMRptRBItemPickView : UIView<UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (void)showReportRBItemPickViewWithFinishBlock:(void(^)(SMRptRBItemModel *model, int optype, NSString *opinion))finishBlock;
-(void)setData:(SMRptRBItemModel*) model;
@end
