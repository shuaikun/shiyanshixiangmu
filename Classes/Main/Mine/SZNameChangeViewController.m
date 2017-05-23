//
//  SZNameChangeViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNameChangeViewController.h"
#import "SZUserEditInfoRequest.h"

@interface SZNameChangeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)onRightButtonClicked:(id)sender;


@end

@implementation SZNameChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"名字"];
    _textField.text = [[UserManager sharedUserManager] realName];
    [self.view bringSubviewToFront:_rightButton];
}

- (void)beginUserEditInfoRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_EDITINFO_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:strongSelf.textField.text forKey:@"real_name"];
        [SZUserEditInfoRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSLog(@"success");
                [[UserManager sharedUserManager] storeUserInfoWithRealName:_textField.text];
                [[ITTPromptView sharedPromptView] showMessage:@"修改成功"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRightButtonClicked:(id)sender
{
    NSLog(@"save");
    if(![[[UserManager sharedUserManager] realName] isEqualToString:_textField.text] && IS_STRING_NOT_EMPTY(_textField.text)){
        [self beginUserEditInfoRequest];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}


@end







