//
//  SZLoginViewController.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SZLoginRequest.h"
#import "AppDelegate.h"
#import "XGPush.h"
#import "SMPushRegTokenRequest.h"

@interface SMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (nonatomic, weak) IBOutlet UIButton *submintBtn;
@property (nonatomic, weak) IBOutlet UIButton *backBtn;
@end

@implementation SMLoginViewController

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
    
    [_mobileField setText:@"demo"];
    [_passwdField setText:@"123456"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnDidClicked:(id)sender {
    if ([self validateAllFiled]) {
        [self hideKeyboard:_passwdField];
        
        
        __weak typeof(self) weakSelf = self;
        NSDictionary *params = @{@"userId":@"241"
                                 ,@"realName":_mobileField.text
                                 ,@"sex":@""
                                 ,@"portrait":@""
                                 ,@"token":@"2132142143214321432143"
                                 ,@"deptname":@"dev"
                                 ,@"role":@"admin"};
        
        [SMLoginViewController loginSucessWithDictionary:params viewController:weakSelf];
        
        /*
        NSDictionary *params = @{@"username":_mobileField.text
                                 ,@"password":_passwdField.text};
        __weak typeof(self) weakSelf = self;
        [SZLoginRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
        {
            [PROMPT_VIEW showActivityWithMask:@"正在登录..."];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //[weakSelf pushReg:request.handleredResult[NETDATA]];
                [SMLoginViewController loginSucessWithDictionary:request.handleredResult[NETDATA] viewController:weakSelf];
            }
            
        } onRequestCanceled:nil onRequestFailed:nil];
         */
    }
}

-(void)pushReg:(NSDictionary *)userInfo
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"userid":[NSString stringWithFormat:@"u%@", userInfo[@"userId"]]
                             ,@"devid":[[UserManager sharedUserManager] apnsId]
                             ,@"appkey":@"123456"
                             ,@"ct":@"ios"};
    NSLog(@"push reg: %@", params);
    [SMPushRegTokenRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
     {
         [PROMPT_VIEW showMessage:@"正在开通推送服务..."];
     } onRequestFinished:^(ITTBaseDataRequest *request) {
         if (request.isSuccess) {
             [PROMPT_VIEW showMessage:@"成功开通推送服务"];
             [SMLoginViewController loginSucessWithDictionary:userInfo viewController:weakSelf];
         }
     } onRequestCanceled:nil onRequestFailed:nil];
}

- (BOOL)validateAllFiled
{
    if (_mobileField.text.length == 0) {
        [PROMPT_VIEW showMessage:@"还未填写用户名"];
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
    //NSString *tag = [NSString stringWithFormat:@"%@:%@", @"userId", userInfo[@"userId"]];
    //[XGPush setTag:tag successCallback:^{
        //[PROMPT_VIEW showMessage:@"成功注册推送服务"];
    //} errorCallback:^{
        //[PROMPT_VIEW showMessage:@"推送服务不可用"];
    //}];
    
    NSLog(@" 登录返回数据 %@",userInfo);
    
    UserManager *userManager = [UserManager sharedUserManager];
    [userManager storeUserInfoWithUserId:userInfo[@"userId"]
                                realName:userInfo[@"realName"]
                                  gender:userInfo[@"sex"]
                             portraitUrl:userInfo[@"portrait"]
                                ssoToken:userInfo[@"token"]
                                deptname:userInfo[@"deptname"]
                                   roles:userInfo[@"role"]
                                 orgType:[userInfo[@"orgType"] integerValue]];
    
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
