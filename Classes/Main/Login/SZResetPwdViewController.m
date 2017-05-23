//
//  SZResetPwdViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZResetPwdViewController.h"
#import "SZResetPwdRequest.h"

@interface SZResetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField2;
@property (nonatomic, weak) IBOutlet UIButton *submintBtn;
@end

@implementation SZResetPwdViewController

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
    // Do any additional setup after loading the view from its nib.
    [_submintBtn setImageName:@"SZ_BTN_RED.png" stretchWithLeft:10.f top:0 forState:UIControlStateNormal];
    [_submintBtn setImageName:@"SZ_BTN_RED_H.png" stretchWithLeft:10.f top:0 forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitBtnDidClicked:(id)sender {
    if ([self validateAllFiled]) {
        NSDictionary *params = @{PARAMS_METHOD_KEY: SZFINDPWD_USER_METHORD
                                 ,@"mobile":_mobileNum
                                 ,@"password":_passwdField.text
                                 ,@"code":_validationCode};
        
        [SZResetPwdRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {

            
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"修改成功"];
                [self popMasterToRootViewController];
            }
            
        } onRequestCanceled:nil onRequestFailed:nil];
    }
}

- (BOOL)validateAllFiled
{
    
    if (self.passwdField.text == 0) {
        [PROMPT_VIEW showMessage:@"还未填写密码"];
        return NO;
    }
    
    if (self.passwdField.text.length<6) {
        [PROMPT_VIEW showMessage:@"密码至少需要6位"];
        return NO;
    }
    
    if (self.passwdField.text.length>32) {
        [PROMPT_VIEW showMessage:@"密码长度超过32位"];
        return NO;
    }
    
    if (self.passwdField2.text == 0) {
        [PROMPT_VIEW showMessage:@"请再填写一遍密码"];
        return NO;
    }
    
    if (![self.passwdField2.text isEqualToString:self.passwdField.text]) {
        [PROMPT_VIEW showMessage:@"密码输入不一致"];
        return NO;
    }
    
    return YES;
}

@end
