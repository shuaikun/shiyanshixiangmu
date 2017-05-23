//
//  SMRptZBAuditPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-15.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditPickView.h"
#import "SMRptZBWeekItemModel.h"
#import "SMRptZBNextweekItemModel.h"
#import "SMRptZBAuditSaveRequest.h"

@interface SMRptZBAuditPickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMRptZBAuditModel *model, int optype, NSString *opinion);

@property (strong, nonatomic) SMRptZBAuditModel *model;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@property (weak, nonatomic) IBOutlet UITextField *leadspeakText;

@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *workcontentItemsLabel;
@property (weak, nonatomic) IBOutlet UIButton *prevWorkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextWorkButton;



@property (weak, nonatomic) IBOutlet UIView *weekPanel;
@property (weak, nonatomic) IBOutlet UILabel *p1timenodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1statusLabel;
@property (weak, nonatomic) IBOutlet UITextView *p1workcontentTextView;
@property (weak, nonatomic) IBOutlet UITextView *p1measuresTextView;
@property (weak, nonatomic) IBOutlet UITextView *p1othersTextView;



@property (weak, nonatomic) IBOutlet UIView *nextWeekPanel;
@property (weak, nonatomic) IBOutlet UILabel *p2levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2timenodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2workcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2measuresLabel;
@property (weak, nonatomic) IBOutlet UITextView *p2othersTextView;



@property (weak, nonatomic) IBOutlet UISegmentedControl *worktypeSelect;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;


@property int curWorkIndex;
@property int workCount;
@property (nonatomic, strong) NSMutableArray *weekItems;
@property (nonatomic, strong) NSMutableArray *nextWeekItems;

@property int selftop;
@property BOOL isAudited;


@end

@implementation SMRptZBAuditPickView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*---------------------------------------------------------------------------
    
    @interface SMRptZBAuditPickView
 
 ---------------------------------------------------------------------------*/

- (void)showReportZBAuditPickViewWithFinishBlock:(void(^)(SMRptZBAuditModel *model, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    _leadspeakText.delegate = self;
    
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}
-(void)setData:(SMRptZBAuditModel*) model
{
    _isAudited = false;
    
    _model = model;
  
    _usernameLabel.text = _model.username;
    _conditionLabel.text = _model.condition;
    _deptnameLabel.text = _model.deptname;
    
    _leadspeakText.text = nil;
    
    [_worktypeSelect setSelectedSegmentIndex:0];
    [_nextWeekPanel setHidden:YES];
    
    self.curWorkIndex = 1;
    if (_weekItems != nil)
    {
        [_weekItems removeAllObjects];
    }
    _weekItems =[_model weeklist];
    
    self.workCount = [_weekItems count];
    [self showWorkContent];
}

- (IBAction)weektypeValueChanged:(id)sender {
    
    self.curWorkIndex = 1;
    if ([sender selectedSegmentIndex] == 0)
    {
        _weekItems =[_model weeklist];
        self.workCount = [_weekItems count];
        
        [_weekPanel setHidden:NO];
        [_nextWeekPanel setHidden:YES];
        
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        _nextWeekItems =[_model nextWeeklist];
        self.workCount = [_nextWeekItems count];
        [_weekPanel setHidden:YES];
        [_nextWeekPanel setHidden:NO];
    }
    
    [_workcontentItemsLabel setTag:[sender selectedSegmentIndex]];
    [self showWorkContent];
}

- (IBAction)prevWorkBtnDidClicked:(id)sender {
    _curWorkIndex -= 1;
    [self showWorkContent];
}
- (IBAction)nextWorkBtnDidClicked:(id)sender {
    _curWorkIndex += 1;
    [self showWorkContent];
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
        NSDictionary *params;
        if ( [_workcontentItemsLabel tag] == 0){
            params = @{
                       @"userid":userid,
                       @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                       @"leadspeak":_leadspeakText.text,
                       @"id":[[_weekItems objectAtIndex:_curWorkIndex-1] id],
                       @"type":@"weekly"
                       };
        }
        else if ( [_workcontentItemsLabel tag] == 1){
            params = @{
                       @"userid":userid,
                       @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                       @"leadspeak":_leadspeakText.text,
                       @"id":[[_nextWeekItems objectAtIndex:_curWorkIndex-1] id],
                       @"type":@"nextWeekly"
                       };
        }
        
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMRptZBAuditSaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"审核完成"];
                
                if ( [_workcontentItemsLabel tag] == 0){
                    [[_weekItems objectAtIndex:_curWorkIndex-1] setLeadspeak:_leadspeakText.text];
                    [[_weekItems objectAtIndex:_curWorkIndex-1] setIsAudited:YES];
                }
                else if ( [_workcontentItemsLabel tag] == 1){
                    [[_nextWeekItems objectAtIndex:_curWorkIndex-1] setLeadspeak:_leadspeakText.text];
                    [[_nextWeekItems objectAtIndex:_curWorkIndex-1] setIsAudited:YES];
                }
                _isAudited = true;
            }
            [PROMPT_VIEW hideWithAnimation];
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hideWithAnimation];
        }];
    }];
    
}




-(void)showWorkContent
{
    _leadspeakText.text = @"";
    _workcontentItemsLabel.text = [NSString stringWithFormat:@"%d / %d", _curWorkIndex, _workCount];
    [_noDataLabel setHidden:YES];
    if (_workCount > 0){
        
        if ( [_workcontentItemsLabel tag] == 0){
            SMRptZBWeekItemModel *item = [_weekItems objectAtIndex:_curWorkIndex-1];
            
            _p1measuresTextView.text = item.measures;
            _p1statusLabel.text = item.status;
            _p1timenodeLabel.text  = item.timenode;
            _p1workcontentTextView.text = item.workcontent;
            _p1othersTextView.text = [NSString stringWithFormat:@"%@ %@ %@",
                                      [item.issue stringByAppendingString:@";"],
                                      [item.solvemeasure stringByAppendingString:@";"],
                                      item.punishment];
            _leadspeakText.text = [item leadspeak];
        }
        else if ([ _workcontentItemsLabel tag] == 1){
            
            SMRptZBNextweekItemModel *item = [_nextWeekItems objectAtIndex:_curWorkIndex-1];
            
            _p2levelLabel.text = item.level;
            _p2measuresLabel.text = item.measures;
            _p2timenodeLabel.text = item.timenode;
            _p2workcontentLabel.text = item.workcontent;
            _p2othersTextView.text = [NSString stringWithFormat:@"%@ %@ %@",
                                      [item.person stringByAppendingString:@";"],
                                      [item.punishment stringByAppendingString:@";"],
                                      item.remark];
            _leadspeakText.text = [item leadspeak];
        }
        
    }
    else{
        [_weekPanel setHidden:YES];
        [_nextWeekPanel setHidden:YES];
        [_noDataLabel setHidden:NO];
    }
    
    
    if (_curWorkIndex - 1 >= 1){
        [_prevWorkButton setEnabled:YES];
    }
    else{
        [_prevWorkButton setEnabled:NO];
    }
    
    if ((_curWorkIndex + 1 <= _workCount) && (_workCount > 0)){
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
