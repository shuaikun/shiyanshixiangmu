//
//  SZLoginViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZLoginViewController.h"
#import "SZRegistViewController.h"
#import "SZFindPwdViewController.h"
#import "SZLoginRequest.h"
#import "AppDelegate.h"
#import "XGPush.h"

@interface SZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (nonatomic, weak) IBOutlet UIButton *submintBtn;
@property (nonatomic, weak) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *regBtn;

@end

@implementation SZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _needHiddenBackBtn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_submintBtn setImageName:@"SZ_BTN_ORANGE.png" stretchWithLeft:10.f top:0 forState:UIControlStateNormal];
    [_submintBtn setImageName:@"SZ_BTN_ORANGE_H.png" stretchWithLeft:10.f top:0 forState:UIControlStateHighlighted];
    [_backBtn setHidden:_needHiddenBackBtn];
    
    [_regBtn setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registBtnDidClicked:(id)sender
{
    SZRegistViewController *registVC = [[SZRegistViewController alloc] initWithNibName:@"SZRegistViewController" bundle:nil];
    [self pushMasterViewController:registVC];
}
- (IBAction)forgetPwdBtnDidClicked:(id)sender
{
    SZFindPwdViewController *findPwdVC = [[SZFindPwdViewController alloc] initWithNibName:@"SZFindPwdViewController" bundle:nil];
    [self pushMasterViewController:findPwdVC];
}
- (IBAction)loginBtnDidClicked:(id)sender {
    
    if ([self validateAllFiled]) {
        [self hideKeyboard:_passwdField];
        NSDictionary *params = @{@"mobile":_mobileField.text
                                 ,@"password":_passwdField.text};
        
        __weak typeof(self) weakSelf = self;
        [SZLoginRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
        {
            [PROMPT_VIEW showActivityWithMask:@"正在登录..."];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [SZLoginViewController loginSucessWithDictionary:request.handleredResult[NETDATA] viewController:weakSelf];
            }
            
        } onRequestCanceled:nil onRequestFailed:nil];
    }
}

- (BOOL)validateAllFiled
{
    if (_mobileField.text.length == 0) {
        [PROMPT_VIEW showMessage:@"还未填写手机号"];
        return NO;
    }
    if(_passwdField.text.length == 0)
    {
        [PROMPT_VIEW showMessage:@"还未填写密码"];
        return NO;
    }
    
    return YES;
}

//注册和成功登录都会走这个方法
+ (void)loginSucessWithDictionary:(NSDictionary *)userInfo
                   viewController:(UIViewController *)viewController
{
    UserManager *userManager = [UserManager sharedUserManager];
    [userManager storeUserInfoWithUserId:userInfo[@"id"]
                                realName:userInfo[@"userName"]
                                  gender:@"-1"
                             portraitUrl:userInfo[@"portrait"]
                                ssoToken:userInfo[@"token"]
                                deptname:[[UserManager sharedUserManager] groupName]
                                   roles:userInfo[@"orgCode"]
                                 orgType:[userInfo[@"orgType"] integerValue]];
    
    
    [[UserManager sharedUserManager] storeUserInfoWithDeptcode:userInfo[@"depCode"]];
    [[UserManager sharedUserManager] storeUserInfoWithDeptname:userInfo[@"depName"]];
    [[UserManager sharedUserManager] storeUserInfoWithGroupCode:userInfo[@"orgCode"]];
    [[UserManager sharedUserManager] storeUserInfoWithGroupName:userInfo[@"orgName"]];
    [[UserManager sharedUserManager ] storeUserInfoWithGroupType:userInfo[@"groupType"]];
    [[UserManager sharedUserManager] storeUserInfoWithMobileNum:userInfo[@"phone"]];
    
    [UserManager didFinishLoginWithviewController:viewController];
//    [self popViewControllerAnyWayWithClass:self];
//    HomeTabBarController *tabBarC = [[AppDelegate GetAppDelegate] tabBarController];
//    for (UINavigationController *nVC in tabBarC.viewControllers) {
//        if ([nVC.visibleViewController isKindOfClass:[SZLoginViewController class]]) {
//            [nVC popViewControllerAnimated:NO];
//        }
//    }
    
}

@end
