//
//  SMRptRBAuditPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptRBAuditListModel.h"

@interface SMRptRBAuditPickView : UIView<UITextFieldDelegate>
- (void)showReportRBAuditPickViewWithFinishBlock:(void(^)(SMRptRBAuditListModel *model, int optype, NSString *opinion))finishBlock;
-(void)setData:(SMRptRBAuditListModel*) model;
@end
