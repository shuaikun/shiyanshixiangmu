//
//  ITTPageTipView.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITTPageTipViewDefaultDismissTime 3  //default dismiss time when in auto dismiss mode

@interface ITTPageTipView : UIView
{
    UIImageView *_tipImageView;
    BOOL        _shouldAutoDismiss;
    int         _dismissTime;
    BOOL        _isDismissed;
}

@property (nonatomic,assign)BOOL shouldAutoDismiss;
@property (nonatomic,assign)int dismissTime;

- (void)setTipImage:(UIImage*)tipImage;

- (void)dismiss;


+ (ITTPageTipView*)showTipViewFromView:(UIView*)parentView 
                                 image:(UIImage*)tipImage
                     shouldAutoDismiss:(BOOL)shouldAutoDismiss
                           dismissTime:(int)dismissTime;

+ (ITTPageTipView*)showTipViewFromView:(UIView*)parentView 
                                 image:(UIImage*)tipImage
                     shouldAutoDismiss:(BOOL)shouldAutoDismiss;
@end
