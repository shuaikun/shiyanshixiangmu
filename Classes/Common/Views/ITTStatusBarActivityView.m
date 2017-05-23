//
//  ITTStatusBarActivityView.m
//  
//
//  Created by jack 廉洁 on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTStatusBarActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface ITTStatusBarActivityView()
- (void)setInProgressStatus;
- (void)setFailStatus;
- (void)setSuccessStatus;
- (void)showWithCompletion:(void (^)(void))completion;
- (void)hideWithCompletion:(void (^)(void))completion;
@end

#define ITTStatusBarActivityViewDisappearTime 2 
@implementation ITTStatusBarActivityView
#pragma mark - private methods

- (void)showWithCompletion:(void (^)(void))completion
{
    if (self.alpha == 0) {
        self.layer.transform = CATransform3DMakeRotation(degreesToRadian(90), 1, 0, 0);
        self.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.layer.transform = CATransform3DMakeRotation(degreesToRadian(0), 1, 0, 0);
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }        
        }];
    }else {
        if (completion) {
            completion();
        }        
    }
}
- (void)hideWithCompletion:(void (^)(void))completion
{
    _statusLbl.text = @"";
    _activityIndicator.alpha = 0;
    self.layer.transform = CATransform3DMakeRotation(degreesToRadian(0), 1, 0, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.transform = CATransform3DMakeRotation(degreesToRadian(90), 1, 0, 0);
    } completion:^(BOOL finished) {
        self.alpha = 0;
        if (completion) {
            completion();
        }        
    }];
}

- (void)setFailStatus
{
    _statusLbl.text = @"发送失败";
    _activityIndicator.alpha = 0;
    [self showWithCompletion:^{
        [self performSelector:@selector(hide) withObject:nil afterDelay:ITTStatusBarActivityViewDisappearTime];
    }];
}

- (void)setSuccessStatus
{
    _statusLbl.text = @"发送成功";
    _activityIndicator.alpha = 0;
    [self showWithCompletion:^{
        [self performSelector:@selector(hide) withObject:nil afterDelay:ITTStatusBarActivityViewDisappearTime];
    }];
}

- (void)setInProgressStatus
{
    _statusLbl.text = @"请求发送中...";
    _activityIndicator.alpha = 1;
    [self showWithCompletion:^{
    }];
}

#pragma mark - public methods

- (void)hide
{
    _statusLbl.text = @"";
    _activityIndicator.alpha = 0;
    [self hideWithCompletion:nil];
}


- (void)setStatus:(ITTStatusBarActivityViewStatus)status
{
    switch (status) {
        case ITTStatusBarActivityViewStatusNone:{
            [self hide];
            break;
        }
        case ITTStatusBarActivityViewStatusSuccess:{
            [self setSuccessStatus];
            break;
        }
        case ITTStatusBarActivityViewStatusFail:{
            [self setFailStatus];
            break;
        }
        case ITTStatusBarActivityViewStatusInProgress:{
            [self setInProgressStatus];
            break;
        }
        default:
            ITTDERROR(@"something is wrong here:status value[%d] not correct",status);
            break;
    }
    _status = status;
}
#pragma mark - lifecycle methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _status = ITTStatusBarActivityViewStatusNone;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end
