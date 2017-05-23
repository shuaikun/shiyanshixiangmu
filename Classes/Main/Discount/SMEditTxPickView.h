//
//  SMEditTxPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendTxModel.h"

@interface SMEditTxPickView : UIView<UITextFieldDelegate>
- (void)showEditTxPickViewWithFinishBlock:(void(^)(SMAttendTxModel *model, int optype, NSString *opinion))finishBlock;
-(void)editData:(SMAttendTxModel*) model;
@end
