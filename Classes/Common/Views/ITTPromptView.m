//
//  ITTPromptView.m
//  ChinaHR
//
//  Created by iPhuan on 12-4-19.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "ITTPromptView.h"
#import <QuartzCore/QuartzCore.h>

#define PROMPT_VIEW_WIDTH      140//160
#define PROMPT_VIEW_HEIGHT     100//120
#define LABEL_LEFT_SPACE       15
#define SUB_MESSAGE_LABEL_DISTANCE_FROM_ACTIVITY   8
#define CENTER_MESSAGE_LABEL_HEIGHT      60
#define MAX_SUB_MESSAGE_LABEL_HEIGHT     40

#define TOP_SHOW_PORTRAIT_Y   80
#define TOP_SHOW_LANDSCAPE_X  320 - 20 - PROMPT_VIEW_HEIGHT  // 屏幕宽 - 电池条高

#define ANIMATION_DURATION   0.3
#define SHOW_DURATION          2

#define BACKGROUND_COLOR            RGBACOLOR(0, 0, 0, 0.7)
#define BACKGROUND_IMAGE            [UIImage imageNamed:@"promptView_bg.png"];
#define BACKGROUND_IMAGE_WHITE      [UIImage imageNamed:@"promptView_bg_white.png"];

@interface ITTPromptView (private)

- (void)isReceiveOrientationChangeNotification:(BOOL)isReceive;

- (void)show;
- (void)showWithEaseOut;
- (void)showWithZoomInPopUp;
- (void)showWithAlertPopUp;
- (void)addAlertPopUpAnimation;

- (void)hideWithEaseIn;
- (void)hideWithZoomOutPopUp;
- (void)hideWithAlertPopUp;

- (void)addMaskView;
- (void)tapOnMaskView;
- (NSInteger)getSubMessageLabelHeight;

- (void)addZoomInOutPopUpAnimationIsZoomIn:(BOOL)isZoomIn;
- (void)addAlertPopUpAnimationIsForward:(BOOL)isForward;
- (void)addAnimationWithValues:(NSArray *)values;

- (void)showInTop;
- (void)showInCenter;

- (void)resetPromptViewForShowType:(ShowType)showType;
- (void)setFitFrame;
- (void)setTopShowFrame;
- (void)setDefaultShowFrame;
- (void)removeSubViews;

- (void)orientationWillChange:(NSNotification*)notifocation;
- (void)setOrientation:(UIInterfaceOrientation)orientation;


@end


@implementation ITTPromptView

@synthesize delegate = _delegate;
@synthesize isShowing = _isShowing;
@synthesize isNeedTopShow = _isNeedTopShow;
@synthesize showType = _showType;
@synthesize style = _style;
@synthesize animationOption = _animationOption;
@synthesize backgroundImagView = _backgroundImagView;
@synthesize customView = _customView;

static ITTPromptView *promptView = nil;

+ (ITTPromptView *)sharedPromptView
{
    @synchronized( self )
    {
        if (promptView == nil) 
        {
            promptView = [[ITTPromptView alloc] init];
            promptView.isNeedTopShow = NO;
//            [promptView setFitFrame];
            promptView.frame = CGRectMake(0, 0, PROMPT_VIEW_WIDTH, PROMPT_VIEW_HEIGHT);
            promptView.center = [UIApplication sharedApplication].keyWindow.center;
            promptView.autoresizesSubviews = NO;
//            promptView.userInteractionEnabled = NO;
            promptView.showType = ShowTypeNo;
            promptView.backgroundColor = BACKGROUND_COLOR;
            promptView.layer.cornerRadius = 7;
            promptView.layer.masksToBounds = YES;
            promptView.animationOption = PromptViewAnimationOptionEaseInOut;
            
            promptView.backgroundImagView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, promptView.width, promptView.height)] autorelease];
            promptView.backgroundImagView.image = nil;
            [promptView addSubview:promptView.backgroundImagView];
            //release promptView.backgroundImagView
            [promptView.backgroundImagView release];
//            [promptView isReceiveOrientationChangeNotification:YES];
            
            [[NSNotificationCenter defaultCenter] addObserver:promptView 
                                                     selector:@selector(showInTop) 
                                                         name:UIKeyboardWillShowNotification 
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:promptView 
                                                     selector:@selector(showInCenter) 
                                                         name:UIKeyboardWillHideNotification 
                                                       object:nil];

        }
        
    }
    
    return promptView;
}

- (void)setStyle:(PromptViewStyle)style
{
    _style = style;
    if (style == PromptViewStyleBlack) 
    {
        _backgroundImagView.image = BACKGROUND_IMAGE;
    }
    else 
    {
        _backgroundImagView.image = BACKGROUND_IMAGE_WHITE;
    }
}


#pragma mark - addObserver

- (void)isReceiveOrientationChangeNotification:(BOOL)isReceive
{
    if (isReceive) 
    {
        [self receiveOrientationChangeNotification];
    }
    else 
    {
        _isReceiveOrientationChangeNotification = NO;
    }
}

- (void)receiveOrientationChangeNotification
{
    _isReceiveOrientationChangeNotification = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:promptView
                                             selector:@selector(orientationWillChange:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)cancelReceiveOrientationChangeNotification
{
    _isReceiveOrientationChangeNotification = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

}

#pragma mark - Common Show API

- (void)showMessage:(NSString *)message
{
    [self resetPromptViewForShowType:ShowTypeMessage];

    if (_centerMessageLabel == nil) 
    {
        _centerMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_SPACE,  round((self.bounds.size.height - CENTER_MESSAGE_LABEL_HEIGHT)/2), self.bounds.size.width - LABEL_LEFT_SPACE * 2 ,CENTER_MESSAGE_LABEL_HEIGHT)];
//        _centerMessageLabel.opaque = NO;
        _centerMessageLabel.numberOfLines = 3;
        _centerMessageLabel.textColor = [UIColor whiteColor];
        _centerMessageLabel.backgroundColor = [UIColor clearColor];
        _centerMessageLabel.font = [UIFont boldSystemFontOfSize:15];
        _centerMessageLabel.textAlignment = UITextAlignmentCenter;
//        _centerMessageLabel.shadowOffset = CGSizeMake(1,1);
//        _centerMessageLabel.shadowColor = [UIColor darkGrayColor];
        _centerMessageLabel.lineBreakMode = UILineBreakModeWordWrap;
//        if (_style == PromptViewStyleBlack) 
//        {
//            _centerMessageLabel.textColor = [UIColor whiteColor];
//            _centerMessageLabel.shadowColor = [UIColor darkGrayColor];
//        }
//        else 
//        {
//            _centerMessageLabel.textColor = RGBACOLOR(0, 0, 0, 0.6);
//            _centerMessageLabel.shadowColor = [UIColor clearColor];
//
//        }
        
        [self addSubview:_centerMessageLabel];
    }
    
    _centerMessageLabel.text = message;
    
    [self show];
}


- (void)showActivity:(NSString *)message;
{
    [self resetPromptViewForShowType:ShowTypeActivity];

    if (_activityIndicatorView == nil) 
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        if (_style == PromptViewStyleWhite) 
        {
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
        
        [_activityIndicatorView startAnimating];
        [self addSubview:_activityIndicatorView];
    }

        
    if (_subMessageLabel == nil) 
    {
        _subMessageLabel = [[UILabel alloc] init];
        _subMessageLabel.numberOfLines = 2;
        _subMessageLabel.textColor = [UIColor whiteColor];
        _subMessageLabel.backgroundColor = [UIColor clearColor];
        _subMessageLabel.font = [UIFont boldSystemFontOfSize:15];
        _subMessageLabel.textAlignment = UITextAlignmentCenter;
        _subMessageLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:_subMessageLabel];
    }
    
    _subMessageLabel.text = message;
    
    NSInteger height = [self getSubMessageLabelHeight];
    
    NSInteger activityFrameY = round((self.bounds.size.height - height - SUB_MESSAGE_LABEL_DISTANCE_FROM_ACTIVITY - _activityIndicatorView.frame.size.height)/2);
    
    _activityIndicatorView.frame = CGRectMake(round((self.bounds.size.width - _activityIndicatorView.frame.size.width)/2), activityFrameY, _activityIndicatorView.frame.size.width, _activityIndicatorView.frame.size.height);
    
    NSInteger subLabelFrameY = activityFrameY + _activityIndicatorView.frame.size.height + SUB_MESSAGE_LABEL_DISTANCE_FROM_ACTIVITY;
    
    _subMessageLabel.frame = CGRectMake(LABEL_LEFT_SPACE,  subLabelFrameY, self.bounds.size.width - LABEL_LEFT_SPACE * 2 ,height);
    _subMessageLabel.numberOfLines = 2;
    
    [self show];
}

- (NSInteger)getSubMessageLabelHeight
{
    CGSize contentSize = [_subMessageLabel.text sizeWithFont:_subMessageLabel.font
                                           constrainedToSize:CGSizeMake(self.bounds.size.width - LABEL_LEFT_SPACE * 2, MAX_SUB_MESSAGE_LABEL_HEIGHT) 
                                               lineBreakMode:UILineBreakModeWordWrap];
    return contentSize.height;
}


- (void)showCustomView:(UIView *)customView
{    
    [self resetPromptViewForShowType:ShowTypeCustomView];

    if (_customView == nil) 
    {
        _customView = [customView retain];
    }
    
    _customView.center = CGPointMake(round(self.bounds.size.width/2), round(self.bounds.size.height/2));
    
    [self addSubview:_customView];
    
    [self show];
}


#pragma mark - Show With MaskView API

- (void)showActivityWithMask:(NSString *)message
{
    [self performSelectorOnMainThread:@selector(addMaskView) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showActivity:) withObject:message waitUntilDone:YES];
}

- (void)showCustomViewWithMask:(UIView *)customView
{
    [self addMaskView];
    [self showCustomView:customView];
}

- (void)addMaskView
{    
    if (_maskView == nil) 
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _maskView = [[UIView alloc] initWithFrame:keyWindow.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMaskView)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_maskView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        [keyWindow addSubview:_maskView];
    }
//    _maskView.alpha = 0;
    _isShowMaskView = YES;
}

- (void)tapOnMaskView
{
    if (_delegate && [_delegate respondsToSelector:@selector(promptViewDidTapOnMaskView:)]) 
    {
        [_delegate promptViewDidTapOnMaskView:self];
    }
}

#pragma mark - Show

- (void)show
{
    switch (_animationOption) 
    {
        case PromptViewAnimationOptionEaseInOut:
            [self showWithEaseOut];
            break;
        case PromptViewAnimationOptionZoomInOutPopUp:
            [self showWithZoomInPopUp];
            break;
        case PromptViewAnimationOptionAlertPopUp:
            [self showWithAlertPopUp];
            break;            
        default:
            break;
    }

}

- (void)showWithEaseOut
{   
    if (!_isShowing) 
    {
        self.alpha = 0;
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.alpha = 1;
            if (_maskView) 
            {
                _maskView.alpha = 1;
            }
        }];
        _isShowing = YES;

    }

    if (_showType == ShowTypeMessage) 
    {
        [self performSelector:@selector(hideWithAnimation) withObject:nil afterDelay:ANIMATION_DURATION + SHOW_DURATION];
    }
}

- (void)showWithZoomInPopUp
{       
    if (!_isShowing) 
    {
        [self addZoomInOutPopUpAnimationIsZoomIn:YES];
        _isShowing = YES;
    }
    
    if (_showType == ShowTypeMessage) 
    {
        [self performSelector:@selector(hideWithAnimation) withObject:nil afterDelay:ANIMATION_DURATION + SHOW_DURATION];
    }    
}

- (void)showWithAlertPopUp
{        
    [self performSelector:@selector(addAlertPopUpAnimation) withObject:nil afterDelay:0.1];
}

- (void)addAlertPopUpAnimation
{
    if (!_isShowing) 
    {
        self.alpha = 1;
        [self addAlertPopUpAnimationIsForward:YES];
        _isShowing = YES;
    }
    
    if (_showType == ShowTypeMessage) 
    {
        [self performSelector:@selector(hideWithAnimation) withObject:nil afterDelay:ANIMATION_DURATION + SHOW_DURATION];
    }
}


#pragma mark - Hidden

- (void)hideWithAnimation
{
    //如果当前未显示则不执行
    if (!_isShowing) 
    {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWithAnimation) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidden) object:nil];

    
    switch (_animationOption) 
    {
        case PromptViewAnimationOptionEaseInOut:
            [self hideWithEaseIn];
            break;
        case PromptViewAnimationOptionZoomInOutPopUp:
            [self hideWithZoomOutPopUp];
            break;
        case PromptViewAnimationOptionAlertPopUp:
            [self hideWithAlertPopUp];
            break;            
        default:
            break;
    }
}

- (void)hideWithEaseIn
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.alpha = 0;
        if (_maskView) 
        {
            _maskView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self hidden];
        }
    }];

}

- (void)hideWithZoomOutPopUp
{
    [self addZoomInOutPopUpAnimationIsZoomIn:NO];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:ANIMATION_DURATION];
}

- (void)hideWithAlertPopUp
{
    [self addAlertPopUpAnimationIsForward:NO];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:ANIMATION_DURATION - 0.1];
}

- (void)hidden
{
    if (!_isShowing) 
    {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidden) object:nil];

    
    _isShowing = NO;
    [self removeSubViews];
    [self removeFromSuperview];
    
    if (_maskView) 
    {
        [_maskView removeFromSuperview];
        [_maskView release];
        _maskView = nil;
    }
    
    //恢复默认transform
    if (_animationOption == PromptViewAnimationOptionZoomInOutPopUp) 
    {
        self.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(promptViewDidHidden)]) 
    {
        [_delegate promptViewDidHidden:self];
    }
}

#pragma mark - Animation

- (void)addZoomInOutPopUpAnimationIsZoomIn:(BOOL)isZoomIn
{        
    if (isZoomIn) 
    {
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        if (_maskView) 
        {
            _maskView.alpha = 0;
        }
    }
    else 
    {
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        if (_maskView) 
        {
            _maskView.alpha = 1;
        }
    }
        
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        if (isZoomIn) 
        {
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
            
            if (_maskView) 
            {
                _maskView.alpha = 1;
            }
        }
        else 
        {
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            if (_maskView) 
            {
                _maskView.alpha = 0;
            }

        }
    }];
}


- (void)addAlertPopUpAnimationIsForward:(BOOL)isForward 
{
    NSMutableArray *values = nil;
    
    NSValue *Value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    NSValue *Value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    NSValue *Value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)];
    NSValue *Value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    
    if (isForward) 
    {
        values = [NSMutableArray arrayWithObjects:Value1, Value2, Value3, Value4, nil];
        
        if (_maskView) 
        {
            _maskView.alpha = 0;
        }
    }
    else
    {  
        values = [NSMutableArray arrayWithObjects:Value4, Value3, Value2, Value1, nil];
        
        if (_maskView) 
        {
            _maskView.alpha = 1;
        }
    }
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        if (isForward) 
        {            
            if (_maskView) 
            {
                _maskView.alpha = 1;
            }
        }
        else
        {              
            if (_maskView) 
            {
                _maskView.alpha = 0;
            }
        }

    }];
    
    [self addAnimationWithValues:values];
}

- (void)addAnimationWithValues:(NSArray *)values
{
    CAKeyframeAnimation *animation=nil;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = ANIMATION_DURATION;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
        
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:nil];
}


#pragma mark - Set Position

- (void)showInTop
{
    _isNeedTopShow = YES;
    
//    if (_isShowing) 
//    {
//        [UIView animateWithDuration:0.4 animations:^{
//            [self setTopShowFrame];
//        }];
//    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setTopShowFrame];
    }];}

- (void)showInCenter
{
    _isNeedTopShow = NO;
    
//    if (_isShowing) 
//    {
//        [UIView animateWithDuration:0.4 animations:^{
//            [self setDefaultShowFrame];
//        }];
//    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setDefaultShowFrame];
    }];

}

#pragma mark - Set PromptView

- (void)resetPromptViewForShowType:(ShowType)showType
{    
    //防止隐藏与显示冲突
    if (_isShowing && self.alpha < 1) 
    {
        [self hidden];
        if (_animationOption == PromptViewAnimationOptionZoomInOutPopUp || _animationOption == PromptViewAnimationOptionAlertPopUp) 
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidden) object:nil];
        }

    }
    
    //解决显示完_maskView后马上显示message遮罩不消失的bug
    if (_isShowMaskView)
    {
        _isShowMaskView = NO;
    }
    else
    {
        if (_maskView)
        {
            [_maskView removeFromSuperview];
            [_maskView release];
            _maskView = nil;

        }
    }
        
    //每次显示时重设Frame
    [self setFitFrame];
    
    if (_isShowing) 
    {
        if (_showType == ShowTypeMessage) 
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWithAnimation) object:nil];
        }
                
        if (_showType != showType) 
        {
            [self removeSubViews];
        }
    }
    else 
    {
        self.alpha = 0;
//        _isShowing = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    _showType = showType;
    
}

- (void)setFitFrame
{
    if (_isNeedTopShow) 
    {
        [self setTopShowFrame];
    }
    else
    {
        [self setDefaultShowFrame];
    }
}

- (void)setTopShowFrame
{
    [promptView setOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect frame = CGRectZero;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        frame = CGRectMake(round((keyWindow.bounds.size.width - PROMPT_VIEW_WIDTH)/2),
                                  TOP_SHOW_PORTRAIT_Y,
                                  PROMPT_VIEW_WIDTH,
                                  PROMPT_VIEW_HEIGHT);

    }
    else 
    {
        frame = CGRectMake(TOP_SHOW_LANDSCAPE_X,
                           round((keyWindow.bounds.size.height - PROMPT_VIEW_WIDTH)/2),
                           PROMPT_VIEW_HEIGHT,
                           PROMPT_VIEW_WIDTH);
    }
        
    self.frame = frame;
}

- (void)setDefaultShowFrame
{
    [promptView setOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect frame = CGRectZero;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        frame = CGRectMake(round((keyWindow.bounds.size.width - PROMPT_VIEW_WIDTH)/2),
                           round((keyWindow.bounds.size.height - PROMPT_VIEW_HEIGHT)/2),
                           PROMPT_VIEW_WIDTH,
                           PROMPT_VIEW_HEIGHT);
    }
    else 
    {
        frame = CGRectMake(round((keyWindow.bounds.size.width - PROMPT_VIEW_HEIGHT)/2),
                           round((keyWindow.bounds.size.height - PROMPT_VIEW_WIDTH)/2),
                           PROMPT_VIEW_HEIGHT,
                           PROMPT_VIEW_WIDTH);
    }

    self.frame = frame;
}

- (void)removeSubViews
{
    for (UIView *subview in self.subviews) 
    {
        if (subview != _backgroundImagView) 
        {
            [subview removeFromSuperview];
        }
    }
    
    switch (_showType) 
    {
        case ShowTypeNo:
            break;
        case ShowTypeMessage:
            if (_centerMessageLabel) 
            {
                [_centerMessageLabel release];
                _centerMessageLabel = nil;
            }
            break;
        case ShowTypeActivity:
            if (_activityIndicatorView) 
            {
                [_activityIndicatorView release];
                _activityIndicatorView = nil;
            }
            
            if (_subMessageLabel)
            {
                [_subMessageLabel release];
                _subMessageLabel = nil;
            }
            
            break;
        case ShowTypeCustomView:
            if (_customView) 
            {
                [_customView release];
                _customView = nil;
            }
            break;
        default:
            break;
    }
}

#pragma mark - Set Orientation

-(void)orientationWillChange:(NSNotification*)notifocation
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[notifocation.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
    
    //不显示时不改变方向
    if (!_isShowing)
    {
        return;
    }
    
    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        [self setOrientation:orientation];
    }];
    //    [self performSelector:@selector(setFitFrame) withObject:nil afterDelay:duration];

    
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    if (!_isReceiveOrientationChangeNotification)
    {
        return;
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.transform = CGAffineTransformMakeRotation(-M_PI);
    }
    else if (orientation == UIInterfaceOrientationPortrait)
    {
        self.transform = CGAffineTransformIdentity;
    }
}


#pragma mark - dealloc

- (void)dealloc
{
    [_centerMessageLabel release];
	[_subMessageLabel release];
    [_backgroundImagView release];
	[_activityIndicatorView release];
    [_maskView release];
    [_customView release];
    
    if (_isReceiveOrientationChangeNotification) 
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	[super dealloc];
}






@end
