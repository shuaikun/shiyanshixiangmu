//
//  PageHelpDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "PageHelpDemoViewController.h"
#import "ITTPageTipView.h"
#import "ITTFirstTouchHelpView.h"

@interface PageHelpDemoViewController ()

@end

@implementation PageHelpDemoViewController

#pragma mark - private method
- (void)setup
{
    self.navTitle = @"新手帮助控件";
}

#pragma mark - lifecycle method
- (id)init
{
    self = [super initWithNibName:@"PageHelpDemoViewController" bundle:nil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - public method

- (IBAction)onAutoDismissTipBtnClicked:(id)sender
{
    [ITTPageTipView showTipViewFromView:self.view
                                  image:[UIImage imageNamed:@"demo_tip.png"] 
                      shouldAutoDismiss:YES 
                            dismissTime:2];
}

- (IBAction)onNormalTipBtnClicked:(id)sender
{
    [ITTPageTipView showTipViewFromView:self.view
                                  image:[UIImage imageNamed:@"demo_tip.png"] 
                      shouldAutoDismiss:NO];
}

- (IBAction)onFirstTouchBtnClicked:(id)sender
{
    NSArray *helpimageArray = [NSArray arrayWithObjects:@"help1.png",@"help2.png",@"help3.png", nil];
    NSArray *iphone5ImageArray = [NSArray arrayWithObjects:@"help1.png",@"help2.png",@"help3.png", nil];
    [[ITTFirstTouchHelpView loadFromXib] startHelpWithHelpImageArray:helpimageArray iphone5ImageArray:iphone5ImageArray];
}
@end
