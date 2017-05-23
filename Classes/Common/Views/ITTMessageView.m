//
//  ITTMessageView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/31/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTMessageView.h"
#import "AppDelegate.h"

#define ITTMessageViewDefaultDisappearTime 2

@interface ITTMessageView()
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation ITTMessageView


#pragma mark - private methods
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

#pragma mark - public methods
+ (void)showMessage:(NSString*)msg disappearAfterTime:(int)time
{
    ITTMessageView *msgView = [ITTMessageView loadFromXib];
    msgView.bottom = 0;
    msgView.left = (320 - msgView.width)/2;
    msgView.messageLbl.text = msg;
    msgView.alpha = 0.0;
    [[UIApplication sharedApplication].delegate.window addSubview:msgView];
    [UIView animateWithDuration:0.5 
                     animations:^{
                         msgView.alpha = 1;
                         msgView.top = 100;
                     } 
                     completion:^(BOOL finished) {
                         [msgView performSelector:@selector(hide) withObject:nil afterDelay:time];
                     }];
}

+ (void)showMessage:(NSString*)msg
{
    int disappearTime = ITTMessageViewDefaultDisappearTime;
    [ITTMessageView showMessage:msg disappearAfterTime:disappearTime];
}

- (void)hide
{
    [UIView animateWithDuration:0.5 
                     animations:^{
                         self.alpha = 0.0;
                         self.bottom = 0;
                     } 
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - lifecycle methods

- (void)dealloc
{
    ITTDINFO(@"message view deallocated");
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
    _disappearTime = 3;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    
}

@end
