//
//  FirstViewController.m
//  TestNavigationViewController
//
//  Created by lian jie on 3/21/13.
//  Copyright (c) 2013 ITT. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)init
{
    self = [super initWithNibName:@"FirstViewController" bundle:nil];
    if (self) {
        // Custom initialization
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

- (IBAction)onNextBtnClicked:(id)sender
{
    SecondViewController *sVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:sVC animated:YES];
}

@end
