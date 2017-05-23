//
//  SZFindPwdViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZFindPwdViewController.h"
#import "SZResetPwdViewController.h"
#import "SZCheckCodeRequest.h"
#import "SZSendCodeRequest.h"
@interface SZFindPwdViewController ()
@property (nonatomic, weak) IBOutlet UIButton *submintBtn;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak,   nonatomic) IBOutlet UIButton *validationCodeBtn;
@end

@implementation SZFindPwdViewController

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
    [self updateValidationInfoBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValidationInfoBtn) name:validationSecondNotificationName object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextBtnDidClicked:(id)sender
{
    if ([self validateAllFiled]) {
        
        __weak typeof(self) weakSelf = self;
        NSDictionary *params = @{PARAMS_METHOD_KEY: SZCHECKCODE_USER_METHORD
                                 ,@"mobile":_mobileField.text
                                 ,@"code":_codeField.text};
        
        [SZCheckCodeRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
         {

         } onRequestFinished:^(ITTBaseDataRequest *request) {
             if (request.isSuccess) {
                 typeof(self) strongSelf = weakSelf;
                 SZResetPwdViewController *resetPwdVC = [[SZResetPwdViewController alloc] initWithNibName:@"SZResetPwdViewController" bundle:nil];
                 [strongSelf pushMasterViewController:resetPwdVC];
                 resetPwdVC.mobileNum = strongSelf.mobileField.text;
                 resetPwdVC.validationCode = strongSelf.codeField.text;
             }
             
         } onRequestCanceled:nil onRequestFailed:nil];
    }
}

- (BOOL)validateAllFiled
{
    if (_mobileField.text.length>0 &&
        _codeField.text.length>0) {
        return YES;
    }
    [PROMPT_VIEW showMessage:@"手机号还未验证"];
    return NO;
}

- (IBAction)obtainValidatinCode:(id)sender
{
    if (self.mobileField.text.length>0 && ![[UserManager sharedUserManager] isOnTimer]) {
        NSDictionary *params = @{PARAMS_METHOD_KEY: SZSENDCODE_USER_METHORD
                                 ,@"mobile":_mobileField.text};
        [SZSendCodeRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
         {
             
         } onRequestFinished:^(ITTBaseDataRequest *request) {
             if (request.isSuccess) {
                 [[UserManager sharedUserManager] startValidationCodeTimer];
             }
             
         } onRequestCanceled:nil onRequestFailed:nil];
    }
    if (self.mobileField.text.length == 0) {
        [PROMPT_VIEW showMessage:@"请输入手机号码"];
    }

}
- (void)updateValidationInfoBtn
{
    NSInteger validationSecond = [UserManager sharedUserManager].validationSecond;
    NSString *leftTime = nil;
    if (validationSecond == 0) {
        leftTime = @"获取验证码";
        [_validationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }else
    {
        leftTime = [NSString stringWithFormat:@"重新获取%d秒",validationSecond];
        [_validationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    [_validationCodeBtn setTitle:leftTime forState:UIControlStateNormal];
}
@end
