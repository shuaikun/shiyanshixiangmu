//
//  WWMobileSettingViewController.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-27.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWMobileSettingViewController.h"
#import "SZCheckCodeRequest.h"
#import "SZSendCodeRequest.h"

@interface WWMobileSettingViewController ()

@property (weak,   nonatomic) IBOutlet UIButton *submintBtn;
@property (weak,   nonatomic) IBOutlet UIButton *validationCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;


@end

@implementation WWMobileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mobileField.text = self.mobile;
    
    [self updateValidationInfoBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValidationInfoBtn) name:validationSecondNotificationName object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)obtainValidatinCode:(id)sender
{
    if (self.mobileField.text.length>0 && self.mobileField.text.length == 11 && ![[UserManager sharedUserManager] isOnTimer]) {
        NSDictionary *params = @{@"mobile":_mobileField.text};
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

- (IBAction)registBtnDIdClicked:(id)sender {
    if ([self validateAllFiled]) {
        
        NSLog(@"block 验证成功");
        
        /*
         //[[UserManager sharedUserManager] storeUserInfoWithRealName:_nameField.text];
         [[UserManager sharedUserManager] storeUserInfoWithUserId:_mobileField.text realName:_nameField.text gender:@"男" portraitUrl:@"" ssoToken:@"tokenslkfdskfkdljsadskafj" deptname:@"" roles:@""];
         [[UserManager sharedUserManager] storeUserInfoWithRealName:_nameField.text];
         
         [UserManager didFinishLoginWithviewController:self];
         */
        
        NSDictionary *params = @{ @"mobile":_mobileField.text
                                 ,@"veriCode":_codeField.text};
        
        [[UserManager sharedUserManager] setInt:1 withKey:[NSString stringWithFormat:@"v%@", _mobileField.text]];
        [[UserManager sharedUserManager] setString:_mobileField.text withKey:WWastePhone];
        [self.navigationController popViewControllerAnyWay];
        
//        __weak typeof(self) weakSelf = self;
//        [SZCheckCodeRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
//            [PROMPT_VIEW showActivityWithMask:@"正在验证..."];
//        } onRequestFinished:^(ITTBaseDataRequest *request) {
//            if (request.isSuccess) {
//                //[SZLoginViewController loginSucessWithDictionary:request.handleredResult[NETDATA] viewController:weakSelf];
//                [[UserManager sharedUserManager] setInt:1 withKey:[NSString stringWithFormat:@"v%@", _mobileField.text]];
//                [[UserManager sharedUserManager] setString:_mobileField.text withKey:WWastePhone];
//                [self.navigationController popViewControllerAnyWay];
//            }
//        } onRequestCanceled:nil onRequestFailed:nil];
        
    }
}

- (BOOL)validateAllFiled
{     if (self.mobileField.text == 0) {
        [PROMPT_VIEW showMessage:@"还未填写手机号码"];
        return NO;
    }
    
    if (self.codeField.text == 0) {
        [PROMPT_VIEW showMessage:@"还未填写验证码"];
        return NO;
    }
    return YES;
}

@end
