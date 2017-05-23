//
//  AppDelegate.h
//  iTotem
//
//  Created by Rainbow on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTStatusBarWindow.h"
#import "ITTIdlingWindow.h"
#import "HomeTabBarController.h"
#import "MYIntroductionView.h"
#import "WWHomePageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) ITTStatusBarWindow *statusBarWindow;
@property (strong, nonatomic) ITTIdlingWindow *window;
@property (strong, nonatomic) HomeTabBarController *tabBarController;
@property (strong, nonatomic) WWHomePageViewController *homePageController;
@property (strong, nonatomic) UINavigationController *masterNavigationController;
@property (strong, nonatomic) MYIntroductionView *introductionView;

+ (AppDelegate*)GetAppDelegate;
- (UINavigationController *)currentNavigationController;

//ShareSDK 分享
- (void)shareWithTitle:(NSString *)title
               content:(NSString *)content
                 image:(UIImage *)image;
- (void)resetTabs;
- (void)postDeviceTokenAndUserInfo:(NSString *)tokenString isOpen:(BOOL)isOpen;
@end
