//
//  SMRptZBAuditPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-15.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBAuditModel.h"

@interface SMRptZBAuditPickView : UIView<UITextFieldDelegate>
- (void)showReportZBAuditPickViewWithFinishBlock:(void(^)(SMRptZBAuditModel *model, int optype, NSString *opinion))finishBlock;
-(void)setData:(SMRptZBAuditModel*) model;

@end
