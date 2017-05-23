//
//  ITTPageTipView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTPageTipView.h"

@interface ITTPageTipView()
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)showFromView:(UIView*)parentView;
@end

@implementation ITTPageTipView

#pragma mark - private methods

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];
}

#pragma mark - lifecycle methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dismissTime = ITTPageTipViewDefaultDismissTime;
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

#pragma mark - public methods

- (void)setTipImage:(UIImage*)tipImage
{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _tipImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_tipImageView];
    }
    _tipImageView.image = tipImage;
}

- (void)dismiss
{
    if (_isDismissed) {
        return;
    }
    _isDismissed = YES;
    // do dismiss
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showFromView:(UIView*)parentView
{
    self.alpha = 0;
    [parentView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (_shouldAutoDismiss) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:_dismissTime];
        }
    }];
}

+ (ITTPageTipView*)showTipViewFromView:(UIView*)parentView 
                                 image:(UIImage*)tipImage
                     shouldAutoDismiss:(BOOL)shouldAutoDismiss
                           dismissTime:(int)dismissTime
{
    ITTPageTipView *tipView = [[ITTPageTipView alloc] initWithFrame:parentView.bounds];
    [tipView setTipImage:tipImage];
    tipView.shouldAutoDismiss = shouldAutoDismiss;
    tipView.dismissTime = dismissTime;
    [tipView showFromView:parentView];
    return tipView;
}

+ (ITTPageTipView*)showTipViewFromView:(UIView*)parentView 
                                 image:(UIImage*)tipImage
                     shouldAutoDismiss:(BOOL)shouldAutoDismiss
{
    return [ITTPageTipView showTipViewFromView:parentView 
                                  image:tipImage 
                      shouldAutoDismiss:shouldAutoDismiss 
                            dismissTime:ITTPageTipViewDefaultDismissTime];
}


@end
