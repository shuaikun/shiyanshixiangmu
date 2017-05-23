//
//  ITTHiddenTabBarViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/1/12.
//  Modified by Sword on 7/10/2012
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTTabBarController.h"

@interface ITTTabBarController()
{

}

@end

@implementation ITTTabBarController

@synthesize contentView = _contentView;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabHeight = _tabHeight;
@synthesize customTabBarView = _customTabBarView;

- (id)init
{
    self = [super init];
    if (self) {
        self.tabBarHidden = FALSE;
    }
    return self;
}

- (void)setContentViewBounds
{
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
		_contentView = [self.view.subviews objectAtIndex:1];
	}
	else {
		_contentView = [self.view.subviews objectAtIndex:0];
	}
    _contentView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame) - self.tabHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ITTDINFO(@"viewDidLoad");
    [self setupTabView];
    [self setContentViewBounds];    
    self.tabBar.hidden = TRUE;
    self.tabBar.alpha = 0.0;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.tabHeight, CGRectGetWidth(self.view.bounds), self.tabHeight);
    self.tabBar.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window bringSubviewToFront:self.customTabBarView];
}


#pragma mark - private methods
- (void)setupTabView
{
    NSString *tabbarClassName = [self tabBarClassName];
    NSAssert(tabbarClassName != nil, @"tabbar class is nil");
    Class tabBarClass = NSClassFromString(tabbarClassName);
    self.customTabBarView = [tabBarClass viewFromNib];
    self.tabHeight = CGRectGetHeight(self.customTabBarView.bounds);
    CGRect frame = self.customTabBarView.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds) - self.tabHeight;
    self.customTabBarView.delegate = self;
    self.customTabBarView.frame  = frame;
//    [self.view addSubview:self.customTabBarView];
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    [window addSubview:self.customTabBarView];
//    [window bringSubviewToFront:self.customTabBarView];
    
    [self.view addSubview:self.customTabBarView];
    [self.view bringSubviewToFront:self.customTabBarView];
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect frame = self.customTabBarView.frame;
    CGRect contentFrame = _contentView.frame;
    ITTDINFO(@"window height %f content height %f content y %f", CGRectGetHeight(window.screen.bounds), CGRectGetHeight(contentFrame), CGRectGetMinY(contentFrame));
    if (_tabBarHidden != tabBarHidden) {
        if (tabBarHidden) {
            frame.origin.y = CGRectGetHeight(self.view.bounds);
            contentFrame.size.height = CGRectGetHeight(window.screen.bounds);
        }
        else {
            frame.origin.y = CGRectGetHeight(self.view.bounds) - self.tabHeight;
            contentFrame.origin.y = 0;
            contentFrame.size.height = CGRectGetHeight(window.screen.bounds) - self.tabHeight;
        }
        if (tabBarHidden) {
            _contentView.frame = contentFrame;
            [UIView animateWithDuration:0.3 animations:^{
                self.customTabBarView.frame = frame;
            }];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                self.customTabBarView.frame = frame;
            } completion:^(BOOL finished) {
                if (finished) {
                    _contentView.frame = contentFrame;
                }
            }];
        }
        _tabBarHidden = tabBarHidden;
    }
}

- (void)setTabBarHidden:(BOOL)tabBarHidden animation:(BOOL)animation
{
    if (animation) {
        [self setTabBarHidden:tabBarHidden];
    }else{
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGRect frame = self.customTabBarView.frame;
        CGRect contentFrame = _contentView.frame;
        ITTDINFO(@"window height %f content height %f content y %f", CGRectGetHeight(window.screen.bounds), CGRectGetHeight(contentFrame), CGRectGetMinY(contentFrame));
        if (_tabBarHidden != tabBarHidden) {
            if (tabBarHidden) {
                frame.origin.y = CGRectGetHeight(self.view.bounds);
                contentFrame.size.height = CGRectGetHeight(window.screen.bounds);
            }
            else {
                frame.origin.y = CGRectGetHeight(self.view.bounds) - self.tabHeight;
                contentFrame.origin.y = 0;
                contentFrame.size.height = CGRectGetHeight(window.screen.bounds) - self.tabHeight;
            }
            if (tabBarHidden) {
                _contentView.frame = contentFrame;
                self.customTabBarView.frame = frame;
            }
            else {
                self.customTabBarView.frame = frame;
                _contentView.frame = contentFrame;
            }
            _tabBarHidden = tabBarHidden;
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.customTabBarView setSelectedIndex:selectedIndex];
    [super setSelectedIndex:selectedIndex];
}

#pragma mark - public 
- (NSString*)tabBarClassName
{
    return nil;
}

#pragma mark - ITTCustomTabBarViewDelegate
- (void) customTabBar:(ITTTabBarView*)tabBar selectedIndex:(NSInteger)index
{
    ITTDINFO(@"selected index %d", index);
    if (self.selectedIndex == index) {
        if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)self.selectedViewController popToRootViewControllerAnimated:TRUE];
        }
    }
    else {
        self.selectedIndex = index;
    }
    NSString *tabBarStr;
    switch (index) {
        case 0:{
            tabBarStr = UMHomePageTabBarClick;
        }
            break;
        case 1:{
            tabBarStr = UMNearByTabBarClick;
        }
            break;
        case 2:{
            tabBarStr = UMDiscountTabBarClick;
        }
            break;
        case 3:{
            tabBarStr = UMMyTabBarClick;

        }
            break;
        case 4:{
            tabBarStr = UMMoreTabBarClick;
        }
            break;
        default:
            break;
    }
    [MobClick event:tabBarStr];
}
@end
