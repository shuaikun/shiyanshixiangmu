//
//  StatusBarWindow.h
//  GuanJiaoTong
//
//  Created by jack 廉洁 on 9/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTStatusBarActivityView.h"
#import "ITTStatusBarMessageView.h"

@interface ITTStatusBarWindow : UIWindow {
    ITTStatusBarActivityView  *_activityView;
    ITTStatusBarMessageView *_messageView;
}
- (void)setActivityViewStatus:(ITTStatusBarActivityViewStatus)status;
- (void)showMessage:(NSString*)msg;
- (void)showMessage:(NSString*)msg withDisappearTime:(int)disappearTime;
- (void)hide;
@end
