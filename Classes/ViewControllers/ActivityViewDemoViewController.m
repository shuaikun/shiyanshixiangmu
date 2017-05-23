//
//  ActivityViewDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ActivityViewDemoViewController.h"
#import "AppDelegate.h"

@interface ActivityViewDemoViewController ()
@end

@implementation ActivityViewDemoViewController
#pragma mark - private methods

- (void)showActivityView
{
    if (!_selectedActivityBtn) {
        return;
    }
    if (_selectedActivityBtn == _maskActivityBtn) {
        if (!_maskActivityView) {
            _maskActivityView = [ITTMaskActivityView loadFromXib];
        }
        [_maskActivityView showInView:self.view];        
    }
    else if(_selectedActivityBtn == _statusBarActivityBtn) {
        [[AppDelegate GetAppDelegate].statusBarWindow setActivityViewStatus:ITTStatusBarActivityViewStatusInProgress];
    }
}

- (void)hideActivityView
{
    if (!_selectedActivityBtn) {
        return;
    }
    if (_selectedActivityBtn == _maskActivityBtn) {
        if (_maskActivityView) {
            [_maskActivityView hide];
        }
    }else if(_selectedActivityBtn == _statusBarActivityBtn){
        [[AppDelegate GetAppDelegate].statusBarWindow setActivityViewStatus:ITTStatusBarActivityViewStatusSuccess];
    }
}

- (void)doSomething
{
    [self showActivityView];
    [self performSelector:@selector(onDoSomethingFinished) withObject:nil afterDelay:3];
}

- (void)onDoSomethingFinished
{
    [self hideActivityView];
}

#pragma mark - lifecycle methods

- (id)init
{
    self = [super initWithNibName:@"ActivityViewDemoViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.navTitle = @"Activity Indicator demo";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navTitle = @"Activity Indicator demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - public methods

- (IBAction)onMaskActivityBtnClicked:(id)sender
{
    _selectedActivityBtn = sender;
    [self doSomething];
}

- (IBAction)onStatusBarActivityBtnClicked:(id)sender
{
    _selectedActivityBtn = sender;
    [self doSomething];
}
@end
