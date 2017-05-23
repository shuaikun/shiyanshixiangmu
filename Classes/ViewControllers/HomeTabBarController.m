//
//  HomeTabBarController.m
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "HomeTabBarController.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}


- (NSString*)tabBarClassName
{
    return @"DemoTabBarView";
}
@end
