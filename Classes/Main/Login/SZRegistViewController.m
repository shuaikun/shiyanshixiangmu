//
//  SZRegistViewController.m
//  KnoweSoft
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 knowesoft. All rights reserved.
//

#import "SZRegistViewController.h"
#import "SZRegistRequest.h"
#import "SZSendCodeRequest.h"
#import "SZLoginViewController.h"
#import "FNLAppointmentProtocalViewController.h"
#import "WWGroupSetViewController.h"

#import <SMS_SDK/SMS_SDK.h>
//#import <SMS_SDK/SMS_SRUtils.h>
#import <SMS_SDK/CountryAndAreaCode.h>

@interface SZRegistViewController ()
@property (weak,   nonatomic) IBOutlet UIImageView *agreeTickImageView;
@property (weak,   nonatomic) IBOutlet UIButton *submintBtn;
@property (weak,   nonatomic) IBOutlet UIButton *validationCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField2;

@property (strong, nonatomic) UIImage *tickSelectedImage;
@property (strong, nonatomic) UIImage *tickUnselectedImage;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *orgField;


@end

@implementation SZRegistViewController
{
    BOOL hasDeptCode;
}

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
    //[_submintBtn setImageName:@"SZ_BTN_BLUE" stretchWithLeft:10.f top:0 forState:UIControlStateNormal];
    //[_submintBtn setImageName:@"SZ_BTN_BLUE_H" stretchWithLeft:10.f top:0 forState:UIControlStateHighlighted];
    _tickSelectedImage = [UIImage imageNamed:@"SZ_BTN_TICK_SELECTED"];
    _tickUnselectedImage = [UIImage imageNamed:@"SZ_BTN_TICK"];
    [self updateValidationInfoBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValidationInfoBtn) name:validationSecondNotificationName object:nil];
    
    [_agreeTickImageView setImage:_tickSelectedImage];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *orgName = [[UserManager sharedUserManager] groupName];
    NSString *deptName = [[UserManager sharedUserManager] deptName];
    if ([deptName length] > 0){
        orgName = [NSString stringWithFormat:@"%@-%@", orgName, deptName];
        hasDeptCode = true;
    }
    else{
        hasDeptCode = false;
    }
    
    [_nameField setText:[[UserManager sharedUserManager] realName]];
    [_orgField setText:orgName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectOrgButtonDidClicked:(id)sender {
    
    WWGroupSetViewController *protApVC = [[WWGroupSetViewController alloc] initWithNibName:@"WWGroupSetViewController" bundle:nil];     [self pushMasterViewController:protApVC];
    
}
- (IBAction)agreeBtnDidClicked:(id)sender {
    
    if (_agreeTickImageView.image == _tickSelectedImage) {
        _agreeTickImageView.image = _tickUnselectedImage;
        [_submintBtn setEnabled:NO];
    }else
    {
        _agreeTickImageView.image = _tickSelectedImage;
        [_submintBtn setEnabled:YES];
    }
}
- (IBAction)obtainValidatinCode:(id)sender
{
    if (self.mobileField.text.length>0 && self.mobileField.text.length == 11 && ![[UserManager sharedUserManager] isOnTimer]) {
        /*
        [SMS_SDK getVerifyCodeByPhoneNumber:self.mobileField.text AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
            if (1==state) {
                NSLog(@"block 获取验证码成功");
                [PROMPT_VIEW showMessage:@"获取验证码成功\n请检查手机短信。"];
            }
            else if(0==state)
            {
                NSLog(@"block 获取验证码失败");
                NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (SMS_ResponseStateMaxVerifyCode==state)
            {
                NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
            {
                NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
        */
        
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
- (IBAction)protocalBtnDidClicked:(id)sender {

    FNLAppointmentProtocalViewController *protApVC = [[FNLAppointmentProtocalViewController alloc] initWithNibName:@"FNLAppointmentProtocalViewController" bundle:nil];
    protApVC.urlStr = [NSString stringWithFormat:@"%@regcond.php?app=index&act=regcond",SZHOST_URL];
    [self pushMasterViewController:protApVC];
    
}
- (IBAction)registBtnDIdClicked:(id)sender {
    if ([self validateAllFiled]) {
        
        //[SMS_SDK commitVerifyCode:_codeField.text result:^(enum SMS_ResponseState state) {
            //if (1==state) {
                NSLog(@"block 验证成功");
                
                /*
                //[[UserManager sharedUserManager] storeUserInfoWithRealName:_nameField.text];
                [[UserManager sharedUserManager] storeUserInfoWithUserId:_mobileField.text realName:_nameField.text gender:@"男" portraitUrl:@"" ssoToken:@"tokenslkfdskfkdljsadskafj" deptname:@"" roles:@""];
                [[UserManager sharedUserManager] storeUserInfoWithRealName:_nameField.text];
                
                [UserManager didFinishLoginWithviewController:self];
                */
        
        NSString *orgCode = [[UserManager sharedUserManager] groupCode];
        if (hasDeptCode){
            orgCode = [[UserManager sharedUserManager] deptCode];
        }
                NSDictionary *params = @{@"org_code": orgCode
                                         ,@"phone":_mobileField.text
                                         ,@"user_name":_nameField.text
                                         ,@"user_password":_passwdField.text
                                         ,@"veriCode":_codeField.text};
                __weak typeof(self) weakSelf = self;
                [SZRegistRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                    [PROMPT_VIEW showActivityWithMask:@"正在注册..."];
                } onRequestFinished:^(ITTBaseDataRequest *request) {
                    if (request.isSuccess) {
                        NSMutableDictionary *data =request.handleredResult[NETDATA];
                        //if [data objectForKey:@"depCode"]
                        [SZLoginViewController loginSucessWithDictionary:data viewController:weakSelf];
                    }
                } onRequestCanceled:nil onRequestFailed:nil];
    /*
            }
    
            else if(0==state)
            {
                NSLog(@"block 验证失败");
                [PROMPT_VIEW showMessage:@"验证码不正确或已失效\n请重新获取验证码"];
            }
        }];
        
    */
    
        
    }
}

- (BOOL)validateAllFiled
{
    if (self.nameField.text == 0){
        [PROMPT_VIEW showMessage:@"还未填写姓名"];
        return NO;
    }
    if (self.orgField.text == 0){
        [PROMPT_VIEW showMessage:@"还未选择所属单位"];
        return NO;
    }
    if (self.mobileField.text == 0) {
        [PROMPT_VIEW showMessage:@"还未填写手机号码"];
        return NO;
    }
    
    if (self.codeField.text == 0) {
        [PROMPT_VIEW showMessage:@"还未填写验证码"];
        return NO;
    }
    
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
