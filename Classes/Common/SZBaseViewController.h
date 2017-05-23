//
//  SZBaseViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBaseTopView.h"

@interface SZBaseViewController : UIViewController<SZBaseTopViewDelegate>

@property (strong, nonatomic) SZBaseTopView * baseTopView;

- (void)setTitle:(NSString *)title;
-(void)setTopViewBackgroundColor:(UIColor*)color;
-(void) setTitleColor:(UIColor*)color;
-(void)setTopViewBackButtonImageStyle:(int)style;
- (void)hiddenBackButton;
- (void)showBackButton;
- (void)hiddenLineView;
- (void)hiddenTopView;
- (void)baseTopViewBackButtonClicked;
- (void)baseTopViewRightButtonClicked;
- (void)takePhoneCall:(NSString *)number;
@end
