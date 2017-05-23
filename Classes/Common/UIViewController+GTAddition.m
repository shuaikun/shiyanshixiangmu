//
//  UIViewController+GTAddition.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "UIViewController+GTAddition.h"
#import "AppDelegate.h"

@implementation UIViewController (GTAddition)



//- (void)presentViewController:(UIViewController*)controller
//{
//    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController];
//    [naviC presentViewController:controller animated:YES completion:nil];
//}

//- (void)presentMasterViewController:(UIViewController*)controller
//{
//    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController];
//    [naviC presentViewController:controller animated:YES completion:nil];
//}

+ (BOOL)containClass:(Class)aClass
{
    NSArray *stacks = [[((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController] viewControllers];
    for (UIViewController *viewController in stacks) {
        if ([viewController isKindOfClass:aClass]) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)containMasterClass:(Class)aClass
{
    NSArray *stacks = [[((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController] viewControllers];
    for (UIViewController *viewController in stacks) {
        if ([viewController isKindOfClass:aClass]) {
            return YES;
        }
    }
    return NO;
}

- (void)pushViewController:(UIViewController*)controller
{
    [UIViewController pushViewController:controller];
}
+ (void)pushViewController:(UIViewController*)controller
{
    [UIView pushViewController:controller];
}

- (BOOL)containViewController:(UIViewController *)controller
{
    return [UIViewController containViewController:controller];
}

+ (BOOL)containViewController:(UIViewController *)controller
{
    NSArray *stacks = [[((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController] viewControllers];
    for (UIViewController *viewController in stacks) {
        if (viewController  == controller) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containMasterViewController:(UIViewController *)controller
{
    return [UIViewController containMasterViewController:controller];
}

+ (BOOL)containMasterViewController:(UIViewController *)controller
{
    NSArray *stacks = [[((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController] viewControllers];
    for (UIViewController *viewController in stacks) {
        if (viewController  == controller) {
            return YES;
        }
    }
    return NO;
}

- (void)pushMasterViewController:(UIViewController*)controller
{
    [self hideKeyboard:nil];
    [UIViewController pushMasterViewController:controller];
}

+ (void)pushMasterViewController:(UIViewController*)controller
{
    [UIView pushMasterViewController:controller];
}

- (void)popMasterViewController;
{
    [UIViewController popMasterViewController];
}

+ (void)popMasterViewController;
{
    [UIView popMasterViewController];
}

- (void)popMasterToRootViewController
{
    [UIViewController popMasterToRootViewController];
}

+ (void)popMasterToRootViewController
{
    [UIView popMasterToRootViewController];
}

- (void)popToRootViewController
{
    [UIViewController popToRootViewController];
}
+ (void)popToRootViewController
{
    [UIView popToRootViewController];
}

- (void)popViewControllerAnyWay
{
    if ([self containViewController:self]) {
        [self popViewController];
    }
    else
    {
        [self popMasterViewController];
    }
}
+ (void)popViewControllerAnyWayWithClass:(Class)aClass
{
    if ([UIViewController containClass:aClass]) {
        [UIViewController popViewController];
    }
    else
    {
        [UIViewController popMasterViewController];
    }
}

- (void)popViewControllerToRootAnyWay
{
    if ([self containViewController:self]) {
        [self popViewController];
    }
    else
    {
        [self popMasterViewController];
    }
}

+ (void)popViewControllerToRootAnyWayWithClass:(Class)aClass
{
    if ([UIViewController containClass:aClass]) {
        [UIViewController popToRootViewController];
    }
    else
    {
        [UIViewController popMasterToRootViewController];
    }
}

- (IBAction)backBtnDidClicked:(id)sender
{
    [self popViewControllerAnyWay];
}
- (IBAction)hideKeyboard:(id)sender
{
    if ([sender respondsToSelector:@selector(isFirstResponder)] && [sender isFirstResponder]) {
        [sender resignFirstResponder];
    }else
    {
        [[self.view findFirstResponder] resignFirstResponder];
    }
}

// private method
- (void)popViewController
{
    [UIViewController popViewController];
}
+ (void)popViewController
{
    [UIView popViewController];
}

@end
