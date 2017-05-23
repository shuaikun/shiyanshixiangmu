//
//  SMAuditTxPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-23.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendTxModel.h"

@interface SMAuditTxPickView : UIView<UITextFieldDelegate>
- (void)showTxPickViewWithFinishBlock:(void(^)(SMAttendTxModel *model, int optype, NSString *opinion))finishBlock;
-(void)editData:(SMAttendTxModel*) model;
@end
