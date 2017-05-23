//
//  ITTPromptView.h
//  ChinaHR
//
//  Created by iPhuan on 12-4-19.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	PromptViewAnimationOptionEaseInOut = 0,
	PromptViewAnimationOptionZoomInOutPopUp,
    PromptViewAnimationOptionAlertPopUp,
} PromptViewAnimationOptions;

typedef enum{
    ShowTypeNo = 0,
    ShowTypeMessage,
    ShowTypeActivity,
    ShowTypeCustomView,
} ShowType;

typedef enum{
    PromptViewStyleBlack = 0,
    PromptViewStyleWhite,
}PromptViewStyle;



@protocol ITTPromptViewDelegate;

@interface ITTPromptView : UIView
{
    UILabel *_centerMessageLabel;
	UILabel *_subMessageLabel;
    UIImageView *_backgroundImagView;
	UIActivityIndicatorView *_activityIndicatorView;
    UIView *_customView;
    UIView  *_maskView;

    id _delegate;
    BOOL _isShowing;
    BOOL _isNeedTopShow;
    BOOL _isShowMaskView;
    BOOL _isReceiveOrientationChangeNotification;
    
    ShowType _showType;
    PromptViewStyle _style;
    PromptViewAnimationOptions _animationOption;
}

@property (nonatomic) BOOL isShowing;
@property (nonatomic) BOOL isNeedTopShow;
@property (nonatomic) ShowType showType;
@property (nonatomic) PromptViewStyle style;
@property (nonatomic) PromptViewAnimationOptions animationOption;
@property (nonatomic, assign) id<ITTPromptViewDelegate> delegate;
@property (nonatomic, retain) UIImageView *backgroundImagView;
@property (nonatomic, retain) UIView *customView;


+ (ITTPromptView *)sharedPromptView;


- (void)receiveOrientationChangeNotification;
- (void)cancelReceiveOrientationChangeNotification;


- (void)showMessage:(NSString *)message;
- (void)showActivity:(NSString *)message;
- (void)showCustomView:(UIView *)customView;

- (void)showActivityWithMask:(NSString *)message;
- (void)showCustomViewWithMask:(UIView *)customView;

- (void)hideWithAnimation;
- (void)hidden;

@end

@protocol ITTPromptViewDelegate <NSObject>

@optional

- (void)promptViewDidHidden:(ITTPromptView *)promptView;
- (void)promptViewDidTapOnMaskView:(ITTPromptView *)promptView;

@end

