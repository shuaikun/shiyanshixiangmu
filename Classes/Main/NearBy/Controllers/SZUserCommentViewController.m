//
//  SZUserCommentViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZUserCommentViewController.h"
#import "SZNearByAddCommentRequest.h"
static NSString *SZCommentDefault = @"输入内容，期待您最真实的评价！";

@interface SZUserCommentViewController ()<UITextViewDelegate>
{
    BOOL _anonymous;
    NSString *_txt;
    NSUInteger _hilightIndex;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *starA;
@property (weak, nonatomic) IBOutlet UIImageView *starB;
@property (weak, nonatomic) IBOutlet UIImageView *starC;
@property (weak, nonatomic) IBOutlet UIImageView *starD;
@property (weak, nonatomic) IBOutlet UIImageView *starE;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *anonImageView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTextLabel;

- (IBAction)handleBackClick:(id)sender;
- (IBAction)handleAddCommentClick:(id)sender;
- (IBAction)handleStarsPan:(id)sender;
- (IBAction)handleContentViewTap:(id)sender;
- (IBAction)handleStarsTap:(id)sender;
- (IBAction)handleAnonImageTap:(id)sender;


@end

@implementation SZUserCommentViewController

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

    _textView.text = SZCommentDefault;
    self.baseTopView.hidden = YES;
    self.starA.highlighted = YES;
    [self.addBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_COMMON_ADD"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_COMMON_ADD_H"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
    [self handleAnonImageTap:nil];//顺序不能动
    _anonymous = NO;
    _hilightIndex = 0;
    self.numberOfTextLabel.hidden = YES;
    if (is4InchScreen()) {
        self.numberOfTextLabel.top = 144.f;
    }else{
        self.numberOfTextLabel.top= 75.f;
    }
    
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(handleDoneAction:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    self.textView.inputAccessoryView = keyboardDoneButtonView;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBackClick:(id)sender {
    [self popMasterViewController];
}

- (void)handleDoneAction:(id)sender
{
    [UIView animateWithDuration:0.1f animations:^(void){
        self.panView.hidden = NO;
        self.lineView.hidden = NO;
        self.editView.height = 248.f;
    }completion:^(BOOL finished){
        
        self.textView.frame = CGRectMake(0, 88, 298, 160);
        self.numberOfTextLabel.hidden = YES;
        if ([[self.textView text]isEqualToString:@""]) {
            self.textView.text = SZCommentDefault;
            self.textView.textColor = [UIColor lightGrayColor];
        }
    }];
    [self.textView resignFirstResponder];
    
}

- (IBAction)handleAddCommentClick:(id)sender {
    if ([[_textView text]length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([[_textView text]isEqualToString:SZCommentDefault]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入评论内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *anonymous = _anonymous?@"1":@"0";
    NSString *content=  [_textView text];
    NSString *score = [NSString stringWithFormat:@"%d",_hilightIndex+1];
    NSString *storeId = self.storeid;
    [[UserManager sharedUserManager]userIdWithLoginBlock:^(NSString *userId,NSString *sosToken){
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:SZNEARBY_ADDSTORECOMMENT,PARAMS_METHOD_KEY,anonymous,@"anonymous",content,@"comment",score,@"score",userId,@"user_id",storeId,@"store_id", nil];
        [SZNearByAddCommentRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_ADD_COMMENT_REQUEST
                                          onRequestStart:^(ITTBaseDataRequest *request){
                                              [PROMPT_VIEW showActivity:@"正在评论..."];
                                          }
                                       onRequestFinished:^(ITTBaseDataRequest *request){
                                           if (request.isSuccess) {
                                               [PROMPT_VIEW showMessage:@"评论成功"];
                                               _textView.text = SZCommentDefault;
                                           }
                                       }
                                       onRequestCanceled:^(ITTBaseDataRequest *request){
                                       }
                                         onRequestFailed:^(ITTBaseDataRequest *request){
                                         } ];
    }];
    

}

- (IBAction)handleStarsPan:(id)sender {
    UITapGestureRecognizer *pan = (UITapGestureRecognizer *)sender;
    CGPoint point = [pan locationInView:self.panView];
    if (point.x<self.starB.left) {
        _hilightIndex = 0;
    }else if (point.x>self.starB.left&&point.x<self.starC.left){
        _hilightIndex = 1;
    }else if (point.x>self.starC.left&&point.x<self.starD.left){
        _hilightIndex = 2;
    }else if (point.x>self.starD.left&&point.x<self.starE.left){
        _hilightIndex = 3;
    }else{
        _hilightIndex = 4;
    }
    [self doHilightedToIndex:_hilightIndex];
}
- (void)doHilightedToIndex:(NSInteger)index
{
    NSArray *stars = [NSArray arrayWithObjects:self.starA,self.starB,self.starC,self.starD,self.starE, nil];
    [stars enumerateObjectsUsingBlock:^(id obj,NSUInteger ind,BOOL *stop){
        UIImageView *star = (UIImageView *)obj;
        if (ind<=index) {
            [star setHighlighted:YES];
        }else{
            [star setHighlighted:NO];
        }
    }];
}
- (IBAction)handleContentViewTap:(id)sender {
    [UIView animateWithDuration:0.1f animations:^(void){
        self.panView.hidden = NO;
        self.lineView.hidden = NO;
        self.editView.height = 248.f;
    }completion:^(BOOL finished){
        
        self.textView.frame = CGRectMake(0, 88, 298, 160);
        self.numberOfTextLabel.hidden = YES;
        if ([[self.textView text]isEqualToString:@""]) {
            self.textView.text = SZCommentDefault;
            self.textView.textColor = [UIColor lightGrayColor];
        }
    }];
    [self.textView resignFirstResponder];
}

- (IBAction)handleStarsTap:(id)sender {
    UITapGestureRecognizer *pan = (UITapGestureRecognizer *)sender;
    CGPoint point = [pan locationInView:self.panView];

    if (point.x<self.starB.left) {
        _hilightIndex = 0;
    }else if (point.x>self.starB.left&&point.x<self.starC.left){
        _hilightIndex = 1;
    }else if (point.x>self.starC.left&&point.x<self.starD.left){
        _hilightIndex = 2;
    }else if (point.x>self.starD.left&&point.x<self.starE.left){
        _hilightIndex = 3;
    }else{
        _hilightIndex = 4;
    }
    [self doHilightedToIndex:_hilightIndex];
}

- (IBAction)handleAnonImageTap:(id)sender
{
    [self.anonImageView setHighlighted:!self.anonImageView.highlighted];
    _anonymous = !_anonymous;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textView text]isEqualToString:SZCommentDefault]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [UIView animateWithDuration:0.1f animations:^(void){
        self.panView.hidden = YES;
        self.lineView.hidden = YES;
        if (is4InchScreen()) {
            self.editView.height = 175.f;
            self.textView.frame = CGRectMake(1, 1, 298, 140);
        }else{
            self.editView.height = 100.f;
            self.textView.frame = CGRectMake(1, 1, 298, 70);
        }

    }completion:^(BOOL finished){
        self.numberOfTextLabel.hidden = NO;
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = [textView text];
    NSInteger count = [text length];
    count = 500 - count;
    if (count>=0) {
        _txt= [textView text];
        self.numberOfTextLabel.text = [NSString stringWithFormat:@"您还可输入%d字",count];
    }else{
        self.numberOfTextLabel.text = [NSString stringWithFormat:@"您输入内容太长"];
    }
    
}
@end
