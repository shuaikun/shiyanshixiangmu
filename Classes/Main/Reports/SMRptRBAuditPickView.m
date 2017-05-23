//
//  SMRptRBAuditPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBAuditPickView.h"
#import "SMRptRBItemModel.h"
#import "SMRptRBAuditSaveRequest.h"

@interface SMRptRBAuditPickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMRptRBAuditListModel *model, int optype, NSString *opinion);

@property (strong, nonatomic) SMRptRBAuditListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UITextView *tommemoLabel;
@property (weak, nonatomic) IBOutlet UITextView *summarizeLabel;

@property (weak, nonatomic) IBOutlet UITextField *leadspeakText;

@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *workcontentItemsLabel;
@property (weak, nonatomic) IBOutlet UIButton *prevWorkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextWorkButton;
@property (weak, nonatomic) IBOutlet UIButton *workMoreButton;
@property (weak, nonatomic) IBOutlet UITextView *workContentTextView;

@property int curWorkIndex;
@property int workCount;
@property (nonatomic, strong) NSMutableArray *workItems;

@property int selftop;
@property BOOL isAudited;


@end

@implementation SMRptRBAuditPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)workMoreBtnDidClicked:(id)sender {
}
- (IBAction)prevWorkBtnDidClicked:(id)sender {
    _curWorkIndex -= 1;
    [self showWorkContent];
}
- (IBAction)nextWorkBtnDidClicked:(id)sender {
    _curWorkIndex += 1;
    [self showWorkContent];
}


- (IBAction)goWorkcontentButtonDidClicked:(id)sender {
    [_leadspeakText resignFirstResponder];
}

- (IBAction)closeBtnDidClicked:(id)sender {
    [_leadspeakText resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            if (_isAudited){
                _finishPickBlock(_model, 1, nil);
            }
            else{
                _finishPickBlock(_model, -1, nil);
            }
        }
    }];
}

- (IBAction)comfirmButtonDidClicked:(id)sender {
    
    [_leadspeakText resignFirstResponder];
    
    if (_workCount == 0){
        [PROMPT_VIEW showMessage:@"无工作需审核"];
        return;
    }
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id": [[_workItems objectAtIndex:_curWorkIndex-1] id],
                                 @"leadspeak":_leadspeakText.text
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptRBAuditSaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"审核完成"];
                [[_workItems objectAtIndex:_curWorkIndex-1] setLeadspeak:_leadspeakText.text];
                [[_workItems objectAtIndex:_curWorkIndex-1] setIsAudited:YES];
                _isAudited = true;
            }
            [PROMPT_VIEW hideWithAnimation];
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hideWithAnimation];
        }];
    }];
}

- (void)showReportRBAuditPickViewWithFinishBlock:(void(^)(SMRptRBAuditListModel *model, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    _leadspeakText.delegate = self;
    
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)setData:(SMRptRBAuditListModel*) model
{
    _isAudited = false;
    
    _model = model;
    
    _dateLabel.text = _model.date;
    _usernameLabel.text = _model.username;
    _conditionLabel.text = _model.condition;
    _deptnameLabel.text = _model.deptname;
    _tommemoLabel.text = _model.tommemo;
    _summarizeLabel.text = _model.summarize;
    _workContentTextView.text = @"无工作安排";
    _leadspeakText.text = nil;
    
    
    self.curWorkIndex = 1;
    if (_workItems != nil)
    {
        [_workItems removeAllObjects];
    }
    _workItems =[_model getListdaily];
    
    self.workCount = [_workItems count];
    [self showWorkContent];
    
}

-(void)showWorkContent
{
    _workcontentItemsLabel.text = [NSString stringWithFormat:@"%d / %d", _curWorkIndex, _workCount];
    if (_workCount > 0){
        SMRptRBItemModel *item = [_workItems objectAtIndex:_curWorkIndex-1];
        _workContentTextView.text = [item workcontent];
        _leadspeakText.text = [item leadspeak];
    }
    if (_curWorkIndex - 1 >= 1){
        [_prevWorkButton setEnabled:YES];
    }
    else{
        [_prevWorkButton setEnabled:NO];
    }
    
    if (_curWorkIndex + 1 <= _workCount && _workCount > 0){
        [_nextWorkButton setEnabled:YES];
    }
    else{
        [_nextWorkButton setEnabled:NO];
    }
        
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [_leadspeakText endEditing:YES];
    [_leadspeakText resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.selftop = self.top;
    CGRect frame = textField.frame;
    int offset = self.top + self.height - frame.origin.y - frame.size.height - 216.0 - 38;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frame =CGRectMake(0, self.selftop, self.frame.size.width, self.frame.size.height);
}


@end
