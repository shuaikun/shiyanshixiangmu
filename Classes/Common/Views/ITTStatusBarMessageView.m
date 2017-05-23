//
//  ITTStatusBarMessageView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/1/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTStatusBarMessageView.h"

#define ITTStatusBarMessageViewDefaultDisappearTime 3

@implementation ITTStatusBarMessageView


- (void)hide
{
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 0;
                     }];
}

- (void)showMessage:(NSString*)msg withDisappearTime:(int)disappearTime
{
    self.alpha = 0;
    _messageLbl.text = msg;
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 1;
                     } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(hide) withObject:nil afterDelay:disappearTime];
                     }];
}

- (void)showMessage:(NSString*)msg
{
    [self showMessage:msg withDisappearTime:ITTStatusBarMessageViewDefaultDisappearTime];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
