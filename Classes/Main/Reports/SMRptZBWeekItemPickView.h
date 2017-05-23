//
//  SMRptZBWeekItemPickView.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-10.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRptZBWeekItemModel.h"

@interface SMRptZBWeekItemPickView : UIView<UITextViewDelegate>
- (void)showReportZBWeekItemPickViewWithFinishBlock:(void(^)(SMRptZBWeekItemModel *model, int optype, NSString *opinion))finishBlock;
-(void)setData:(SMRptZBWeekItemModel*) model;
@end
