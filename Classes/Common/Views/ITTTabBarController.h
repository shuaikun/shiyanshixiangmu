//
//  ITTHiddenTabBarViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/1/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTTabBarView.h"

@interface ITTTabBarController : UITabBarController<ITTCustomTabBarViewDelegate>
{
    BOOL                _tabBarHidden;
    UIView              *_contentView;
    ITTTabBarView       *_customTabBarView;
}

@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, assign) CGFloat tabHeight;
@property (nonatomic, strong) ITTTabBarView *customTabBarView;
@property (nonatomic, strong, readonly) UIView *contentView;

- (void)setContentViewBounds;

//subclass must override this method to sepcify tabbar class
- (NSString*)tabBarClassName;

- (void)setTabBarHidden:(BOOL)tabBarHidden animation:(BOOL)animation;
@end
