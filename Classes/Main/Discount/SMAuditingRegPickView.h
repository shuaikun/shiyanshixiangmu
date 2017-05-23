//
//  SMAuditingRegPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-8.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendRegModel.h"

@interface SMAuditingRegPickView : UIView<UITextFieldDelegate>
- (void)showAuditingRegPickViewWithFinishBlock:(void(^)(SMAttendRegModel *regModel, int optype, NSString *opinion))finishBlock;
-(void)auditingRegData:(SMAttendRegModel*) regModel;
@end
