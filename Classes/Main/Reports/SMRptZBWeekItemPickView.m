//
//  SMRptZBWeekItemPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-10.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBWeekItemPickView.h"
#import "UIUtil.h"

@interface SMRptZBWeekItemPickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMRptZBWeekItemModel *model, int optype, NSString *opinion);


@property (weak, nonatomic) IBOutlet UITextView *workcontentTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSelect;
@property (weak, nonatomic) IBOutlet UITextView *measuresTextView;
@property (weak, nonatomic) IBOutlet UIButton *dateSelect;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textViewTypeSelect;
@property (weak, nonatomic) IBOutlet UITextView *issueTextView;
@property (weak, nonatomic) IBOutlet UITextView *solvemeasureTextView;
@property (weak, nonatomic) IBOutlet UITextView *punishmentTextView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;



@property (strong, nonatomic) SMRptZBWeekItemModel *model;

@property float selftop;

@end


@implementation SMRptZBWeekItemPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
    }
    return self;
}




-(void)clearPickerView
{
    if (_workcontentTextView != nil){
        [self.workcontentTextView endEditing:YES];
        [self.issueTextView endEditing:YES];
        [self.measuresTextView endEditing:YES];
        [self.punishmentTextView endEditing:YES];
        [self.solvemeasureTextView endEditing:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _datePickerView.top = self.bottom;
    }];
}


- (IBAction)datePickerChanged:(id)sender {
    
    [_dateSelect setTitle:[UIUtil getDateString:[sender date]] forState:UIControlStateNormal];
    _model.timenode = [[_dateSelect titleLabel] text];
    
}
- (IBAction)dateSelectDidClicked:(id)sender {
    [self clearPickerView];
    [_datePickerView setHeight:_datePicker.height];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _datePickerView.top = weakSelf.height - _datePickerView.height;
        
    }];
}

- (IBAction)statusSelectChanged:(id)sender {
    [self clearPickerView];
}
- (IBAction)textViewTypeChanged:(id)sender {
    [self clearPickerView];
    [_issueTextView setHidden:YES];
    [_solvemeasureTextView setHidden:YES];
    [_punishmentTextView setHidden:YES];
    
    if ([sender selectedSegmentIndex ] == 0){
        [_issueTextView setHidden:NO];
    }
    else if ([sender selectedSegmentIndex] == 1){
        [_solvemeasureTextView setHidden:NO];
    }
    else if ([sender selectedSegmentIndex] == 2){
        [_punishmentTextView setHidden:NO];
    }
}

- (IBAction)closeBtnClick:(id)sender {
    
    [self clearPickerView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_model, -1, nil);
        }
    }];
    
}

- (IBAction)BtnClicked:(id)sender {
    
    [self clearPickerView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_model, 1, nil);
        }
    }];
}
-(void)collectdata{
    _model.workcontent = [self.workcontentTextView text];
    
    _model.status = [self.statusSelect titleForSegmentAtIndex:self.statusSelect.selectedSegmentIndex];
    _model.timenode = _dateSelect.titleLabel.text;
    _model.measures = _measuresTextView.text;
    _model.issue =  [self.issueTextView text];
    _model.solvemeasure = _solvemeasureTextView.text;
    _model.punishment = _punishmentTextView.text;
    
}

- (void)showReportZBWeekItemPickViewWithFinishBlock:(void(^)(SMRptZBWeekItemModel *model, int optype, NSString *opinion))finishBlock
{
    self.workcontentTextView.delegate = nil;
    self.issueTextView.delegate=nil;
    self.workcontentTextView.delegate = self;
    self.issueTextView.delegate = self;
    
    self.measuresTextView.delegate = nil;
    self.measuresTextView.delegate= self;
    
    self.punishmentTextView.delegate = nil;
    self.punishmentTextView.delegate = self;
    
    self.solvemeasureTextView.delegate = nil;
    self.solvemeasureTextView.delegate = self;
    
    self.finishPickBlock = finishBlock;
    
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)setData:(SMRptZBWeekItemModel*) model
{
    if (model == nil){
        _model = [[SMRptZBWeekItemModel alloc] init];
        _model.id = @"";
        _model.timenode = [UIUtil getDateString:[NSDate new]];
    }
    else{
        _model = model;
    }
    
    _workcontentTextView.text = _model.workcontent;
    _measuresTextView.text = _model.measures;
    [_dateSelect setTitle:_model.timenode forState:UIControlStateNormal];
    _issueTextView.text = _model.issue;
    _punishmentTextView.text = _model.punishment;
    _solvemeasureTextView.text = _model.solvemeasure;
    
    _datePickerView.top = self.bottom;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    
    [self clearPickerView];
    
    [super touchesBegan:touches withEvent:event];
}


/*  ===================================================================
 
 TextView Delegate .....
 
 */

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.frame =CGRectMake(0, weakSelf.selftop, weakSelf.frame.size.width, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        [textView resignFirstResponder];
    }];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self clearPickerView];
    
    self.selftop = self.top;
    CGRect frame = textView.frame;
    int offset = self.top + self.height - frame.origin.y - frame.size.height - 216.0 - 38;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
