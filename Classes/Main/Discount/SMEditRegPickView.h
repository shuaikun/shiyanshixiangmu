//
//  SMEditRegPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-19.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendRegModel.h"

@interface SMEditRegPickView : UIView<UITextFieldDelegate>
- (void)showEditRegPickViewWithFinishBlock:(void(^)(SMAttendRegModel *regModel, int optype, NSString *opinion))finishBlock;
-(void)editRegData:(SMAttendRegModel*) regModel;
@end
