//
//  StatusBarWindow.m
//  GuanJiaoTong
//
//  Created by jack 廉洁 on 9/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTStatusBarWindow.h"
#import "ITTStatusBarActivityView.h"
#import "ITTStatusBarMessageView.h"
#import "AppDelegate.h"

@interface ITTStatusBarWindow()
- (void)setupActivityView;
- (void)setupMessageView;
@end

@implementation ITTStatusBarWindow

#pragma mark - private methods
- (void)setupActivityView
{
    if (!_activityView) {
        _activityView = [ITTStatusBarActivityView loadFromXib];
        _activityView.alpha = 0;
        _activityView.frame = self.bounds;
        [self addSubview:_activityView];       
        
        [_activityView setStatus:ITTStatusBarActivityViewStatusNone];
    }
}

- (void)setupMessageView
{
    if (!_messageView) {
        _messageView = [ITTStatusBarMessageView loadFromXib];
        [self addSubview:_messageView];    
    }
}

#pragma mark - lifecycle methods
- (id)init
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 20)])) {
        // Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.0f;
        self.frame = [[UIApplication sharedApplication] statusBarFrame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)hide
{
    if (_activityView && _activityView.alpha != 0) {
        [_activityView hide];
    }
    if (_messageView && _messageView.alpha != 0) {
        [_messageView hide];
    }
}


#pragma mark - public methods
- (void)showMessage:(NSString*)msg
{
    [self showMessage:msg withDisappearTime:-1];
}

- (void)showMessage:(NSString*)msg withDisappearTime:(int)disappearTime
{
    if (!_messageView) {
        [self setupMessageView];
    }
    //show current window
    [self makeKeyAndVisible];
    
    [self hide];
    if (disappearTime > 0) {
        [_messageView showMessage:msg withDisappearTime:disappearTime];
    }else{
        [_messageView showMessage:msg];
    }
    // restore default window
    [[AppDelegate GetAppDelegate].window makeKeyWindow];
}

- (void)setActivityViewStatus:(ITTStatusBarActivityViewStatus)status
{
    if (!_activityView) {
        [self setupActivityView];
    }
    //show current window
    [self makeKeyAndVisible];
    
    [self hide];
    [_activityView setStatus:status];
    
    // restore default window
    [[AppDelegate GetAppDelegate].window makeKeyWindow];
}

@end
