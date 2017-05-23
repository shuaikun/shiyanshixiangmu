//
//  SMAuditingLeavePickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendLeaveModel.h"

@interface SMAuditingLeavePickView : UIView<UITextFieldDelegate>
- (void)showAuditingLeavePickViewWithFinishBlock:(void(^)(SMAttendLeaveModel *regModel, int optype, NSString *opinion))finishBlock;
-(void)auditingLeaveData:(SMAttendLeaveModel*) regModel;
@end
