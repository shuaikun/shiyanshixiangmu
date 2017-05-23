//
//  SecondViewController.m
//  TestNavigationViewController
//
//  Created by lian jie on 3/21/13.
//  Copyright (c) 2013 ITT. All rights reserved.
//

#import "SecondViewController.h"
#import "ITTDrawerNavigationViewController.h"
#import "UIView+ITTAdditions.h"
#import "ThirdViewController.h"

@interface SecondViewController ()
{
}
@end

@implementation SecondViewController


- (id)init
{
    self = [super initWithNibName:@"SecondViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNextBtnClicked:(id)sender
{
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:thirdVC animated:YES];
}


@end
