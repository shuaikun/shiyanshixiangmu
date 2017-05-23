//
//  ViewController.m
//  LockDemo
//
//  Created by 胡鹏 on 7/30/13.
//  Copyright (c) 2013 isoftStone. All rights reserved.
//

#import "LockViewDemoViewController.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface LockViewDemoViewController () {
    
    ITTLockView *_lockView;
    
}

- (IBAction)setButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *originalPasswordTextField;

@end

@implementation LockViewDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lockView = [[ITTLockView alloc] initWithFrame:CGRectMake(0, 200, 320, 280) circleRadius:20 circleColor:[UIColor redColor] circleThickness:4.0 circleFillColor:[UIColor greenColor]];
    _lockView.backgroundColor = [UIColor clearColor];
    _lockView.lineColor = [UIColor purpleColor];
    //设置是否能跳点连接
    _lockView.canSkipConnect = true;
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
//    [_lockView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = YES;
}

- (void)viewDidUnload
{
    [self setCurrentPasswordTextField:nil];
    [self setOriginalPasswordTextField:nil];
    [super viewDidUnload];
}


- (IBAction)setButtonClicked:(id)sender
{
    _originalPasswordTextField.text = _currentPasswordTextField.text;
    [_lockView resetInterface];
}

- (IBAction)resetButtonClicked:(id)sender
{
    
    [_lockView resetInterface];
    _currentPasswordTextField.text = nil;
    _originalPasswordTextField.text = nil;
    
}

- (IBAction)checkButtonClicked:(id)sender
{
    if ([self.currentPasswordTextField isFirstResponder]) {
        [self.currentPasswordTextField resignFirstResponder];
    }
    if ([self.originalPasswordTextField isFirstResponder]) {
        [self.originalPasswordTextField resignFirstResponder];
    }
    NSString *message = @"";
    if ([_currentPasswordTextField.text isEqualToString:_originalPasswordTextField.text]) {
        message = @"验证OK！";
        [self resetButtonClicked:nil];
    }
    else {
        message = @"验证失败！";
        _lockView.currentState = falseState;
        _lockView.touchesEnabled = false;
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
//    [alert release];
}
        
#pragma mark - ITTLockViewDelegate
- (void)touchesEnd:(ITTLockView *)lockView
{
    _currentPasswordTextField.text = [lockView.selectedIndexs componentsJoinedByString:@","];
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
@end
