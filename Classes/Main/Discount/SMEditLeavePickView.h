//
//  SMEditLeavePickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-21.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendLeaveModel.h"

@interface SMEditLeavePickView : UIView<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (void)showEditLeavePickViewWithFinishBlock:(void(^)(SMAttendLeaveModel *model, int optype, NSString *opinion))finishBlock;
-(void)editLeaveData:(SMAttendLeaveModel*) model;
@end
