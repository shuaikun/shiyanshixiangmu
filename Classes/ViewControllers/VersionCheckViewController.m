//
//  VersionCheckViewController.m
//  iTotemFramework
//
//  Created by Sword on 13-12-17.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "VersionCheckViewController.h"
#import "ITTVersionController.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"
#import "VersionCheckDataRequest.h"

@interface VersionCheckViewController ()

@end

@implementation VersionCheckViewController

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
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (IBAction)onVersionCheckBtnTouched:(id)sender
{
    NSDictionary *params = nil; //your request params here, pass null for demo
    [VersionCheckDataRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        ITTVersion *storeVersion = request.handleredResult[KEY_VERSION];
        [VERSION_CONTROLLER checkUpdateWithVersion:storeVersion];
    }];
}

@end
