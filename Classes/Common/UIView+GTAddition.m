//
//  UIView+GTAddition.m
//  iTotemFramework
//
//  Created by Grant on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "UIView+GTAddition.h"
#import "AppDelegate.h"
@implementation UIView (GTAddition)
- (void)pushMasterViewController:(UIViewController*)controller{
    [UIView pushMasterViewController:controller];
}

+ (void)pushMasterViewController:(UIViewController*)controller
{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController];
    [naviC pushViewController:controller animated:YES];
}

+ (void)popMasterViewController
{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController];
    [naviC popViewControllerAnimated:YES];
}

- (void)popMasterViewController{
    [UIView popMasterViewController];
}

+ (void)popViewController
{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController];
    [naviC popViewControllerAnimated:YES];
}

- (void)popViewController
{
    [UIView popViewController];
}

+ (void)popToRootViewController
{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController];
    [naviC popToRootViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController*)controller{
    [UIView pushMasterViewController:controller];
}

+ (void)pushViewController:(UIViewController*)controller{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) currentNavigationController];
    [naviC pushViewController:controller animated:YES];
}

+ (void)popMasterToRootViewController
{
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController];
    [naviC popToRootViewControllerAnimated:YES];
}

- (void)setupBorderWidth:(UIEdgeInsets)widthEdge
                topColor:(UIColor *)topColor
               leftColor:(UIColor *)leftColor
             bottomColor:(UIColor *)bottomColor
              rightColor:(UIColor *)rightColor
{
    if (widthEdge.top == widthEdge.left && widthEdge.top == widthEdge.bottom && widthEdge.top == widthEdge.right &&
        topColor == leftColor && topColor == bottomColor && topColor == rightColor)
    {
        self.layer.borderWidth = widthEdge.top;
        self.layer.borderColor = topColor.CGColor;
    }else
    {
        if (widthEdge.top>0) {
            CALayer *topLayer = [[CALayer alloc] init];
            topLayer.frame = CGRectMake(0, 0, self.width, widthEdge.top);
            [self.layer addSublayer:topLayer];
            topLayer.backgroundColor = topColor.CGColor;
        }
        
        if (widthEdge.left>0) {
            CALayer *leftLayer = [[CALayer alloc] init];
            leftLayer.frame = CGRectMake(0, 0, widthEdge.left, self.height);
            [self.layer addSublayer:leftLayer];
            leftLayer.backgroundColor = leftColor.CGColor;
        }
        
        if (widthEdge.bottom>0) {
            CALayer *bottomLayer = [[CALayer alloc] init];
            bottomLayer.frame = CGRectMake(0, self.height-widthEdge.bottom, self.width, widthEdge.bottom);
            [self.layer addSublayer:bottomLayer];
            bottomLayer.backgroundColor = bottomColor.CGColor;
        }
        
        if (widthEdge.right>0) {
            CALayer *rightLayer = [[CALayer alloc] init];
            rightLayer.frame = CGRectMake(self.width-widthEdge.right, 0, widthEdge.right, self.height);
            [self.layer addSublayer:rightLayer];
            rightLayer.backgroundColor = rightColor.CGColor;
        }
    }
    
    

}

- (void)setupBorderWidth:(UIEdgeInsets)widthEdge
                allColor:(UIColor *)allColor
{
    [self setupBorderWidth:widthEdge topColor:allColor leftColor:allColor bottomColor:allColor rightColor:allColor];
}


@end
