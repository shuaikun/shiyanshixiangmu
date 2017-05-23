//
//  AutoLayoutDemoViewController.m
//  iTotemFramework
//
//  Created by lian jie on 9/18/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "AutoLayoutDemoViewController.h"

@interface AutoLayoutDemoViewController ()

@end

@implementation AutoLayoutDemoViewController

#pragma mark - lifecycle methods

- (id)init
{
    self = [super initWithNibName:@"AutoLayoutDemoViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.navTitle = @"auto layout demo";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navTitle = @"auto layout demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - public methods
@end
