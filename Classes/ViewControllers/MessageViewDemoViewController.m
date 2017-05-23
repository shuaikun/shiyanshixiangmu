//
//  MessageViewDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/1/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "MessageViewDemoViewController.h"
#import "ITTMessageView.h"
#import "ITTAlertView.h"
#import "AppDelegate.h"
#import "DemoAlertView.h"

@interface MessageViewDemoViewController ()

@end

@implementation MessageViewDemoViewController
#pragma mark - private methods
#pragma mark - lifecyle methods

- (void)setup
{
    self.navTitle = @"message view demo";
}

- (id)init
{
    self = [super initWithNibName:@"MessageViewDemoViewController" bundle:nil];
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
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - public methods

- (IBAction)onNormalMessageViewBtnClicked:(id)sender
{
    [ITTMessageView showMessage:@"提示信息提示信息提示信息" disappearAfterTime:2];
}

- (IBAction)onAlertViewBtnClicked:(id)sender
{
//    [ITTAlertView alertWithMessage:@"ITTAlertView好不好用？" 
//                         cancelBtn:@"不好用" 
//                        confirmBtn:@"好用" 
//                          onCancel:^{
//                              ITTDINFO(@"cancel btn clicked");
//                          }
//                         onConfirm:^{
//                             ITTDINFO(@"confirm btn clicked");
//                         }];
    ITTAlertView *alertView = [DemoAlertView loadFromXib];
    [alertView showInView:self.view onCancel:^(void){
        ITTDINFO(@"cancel");
    } onConfirm:^(void){
        ITTDINFO(@"confirm");        
    }];
}

- (IBAction)statusBarMessageBtnClicked:(id)sender
{
    //[[AppDelegate GetAppDelegate].statusBarWindow showMessage:@"状态栏提示"];
    [[AppDelegate GetAppDelegate].statusBarWindow showMessage:@"状态栏提示" withDisappearTime:2];
}
@end
