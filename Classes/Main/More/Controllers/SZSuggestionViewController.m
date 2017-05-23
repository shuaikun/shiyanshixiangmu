//
//  SZSuggestionViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZSuggestionViewController.h"
#import "SZMoreCommentFeedBackRequest.h"
#import "IdentifierValidator.h"
@interface SZSuggestionViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)handleBackClick:(id)sender;
- (IBAction)handleTapContentViewClick:(id)sender;
- (IBAction)handleCommitClick:(id)sender;

@end

@implementation SZSuggestionViewController

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
    self.baseTopView.hidden = YES;
    [self.commitBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_BTN_RED"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_BTN_RED_H"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textView text]isEqualToString:@"请输入您的反馈意见 （500字以内）"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView text]length]>500) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的字数已经超过500字。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!is4InchScreen()) {
        [UIView animateWithDuration:0.35f animations:^(void){
        self.contentView.top-=100.f;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!is4InchScreen()) {
        [UIView animateWithDuration:0.35f animations:^(void){
            self.contentView.top+=100.f;
        }];
    }
}

- (IBAction)handleBackClick:(id)sender {
    [self popMasterViewController];
}

- (IBAction)handleTapContentViewClick:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (IBAction)handleCommitClick:(id)sender {
    if ([[self.textView text]length]==0||[[self.textView text]isEqualToString:@"请输入您的反馈意见 （500字以内）"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有输入反馈意见哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([[self.phoneNumberTextField text]length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入邮箱或者电话号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (!([IdentifierValidator isValid:IdentifierTypeEmail value:self.phoneNumberTextField.text]||[IdentifierValidator isValid:IdentifierTypePhone value:self.phoneNumberTextField.text])) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮箱或者手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else{
        NSString *content = [self.textView text];
        NSString *model = [[UIDevice currentDevice]model];
        NSString *contact = [self.phoneNumberTextField text];
        [[UserManager sharedUserManager]userIdWithLoginBlock:^(NSString *userId, NSString *sodToken){
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:SZMORE_RECOMMENT,PARAMS_METHOD_KEY,contact,@"contact",content,@"content",userId,@"user_id",model,@"model", nil];
            [SZMoreCommentFeedBackRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_COMMENT_FEEDBACK_REQUEST
                                                 onRequestStart:^(ITTBaseDataRequest *request){
                                                     [PROMPT_VIEW showActivity:@"..."];
                                                 }
                                              onRequestFinished:^(ITTBaseDataRequest *request){
                                                  if (request.isSuccess) {
                                                      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"意见反馈成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                      [alertView show];
                                                  }
                                                  
                                              } onRequestCanceled:^(ITTBaseDataRequest *request){
                                                  
                                              } onRequestFailed:^(ITTBaseDataRequest *request){
                                                  
                                              }];
        }];
        
        
        
        
    }
}
@end
