//
//  UIViewController+GTAddition.h
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GTAddition)

//- (void)presentViewController:(UIViewController*)controller;
//- (void)presentMasterViewController:(UIViewController*)controller;

+ (BOOL)containClass:(Class)aClass;
+ (BOOL)containMasterClass:(Class)aClass;

- (void)pushViewController:(UIViewController*)controller;
+ (void)pushViewController:(UIViewController*)controller;

- (BOOL)containViewController:(UIViewController *)controller;
+ (BOOL)containViewController:(UIViewController *)controller;

- (BOOL)containMasterViewController:(UIViewController *)controller;
+ (BOOL)containMasterViewController:(UIViewController *)controller;

- (void)pushMasterViewController:(UIViewController*)controller;
+ (void)pushMasterViewController:(UIViewController*)controller;

- (void)popMasterViewController;
+ (void)popMasterViewController;

- (void)popMasterToRootViewController;
+ (void)popMasterToRootViewController;

- (void)popViewControllerAnyWay;
+ (void)popViewControllerAnyWayWithClass:(Class)aClass;

- (void)popViewControllerToRootAnyWay;

+ (void)popViewControllerToRootAnyWayWithClass:(Class)aClass;

- (IBAction)backBtnDidClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
