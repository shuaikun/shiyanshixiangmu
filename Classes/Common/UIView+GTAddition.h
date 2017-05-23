//
//  UIView+GTAddition.h
//  iTotemFramework
//
//  Created by Grant on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GTAddition)
- (void)pushMasterViewController:(UIViewController*)controller;
+ (void)pushMasterViewController:(UIViewController*)controller;

- (void)pushViewController:(UIViewController*)controller;
+ (void)pushViewController:(UIViewController*)controller;

- (void)popViewController;
+ (void)popViewController;

+ (void)popToRootViewController;

- (void)popMasterViewController;
+ (void)popMasterViewController;

+ (void)popMasterToRootViewController;

- (void)setupBorderWidth:(UIEdgeInsets)widthEdge
                topColor:(UIColor *)topColor
               leftColor:(UIColor *)leftColor
             bottomColor:(UIColor *)bottomColor
              rightColor:(UIColor *)rightColor;

- (void)setupBorderWidth:(UIEdgeInsets)widthEdge
                allColor:(UIColor *)allColor;


@end
