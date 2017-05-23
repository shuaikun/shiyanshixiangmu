//
//  SMEditTxPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMEditTxPickView.h"

@interface SMEditTxPickView()
@property (nonatomic, copy) void(^finishPickBlock)(SMAttendTxModel *model, int optype, NSString *opinion);
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *extraworkDateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *extraworkTimeSelect;
@property (weak, nonatomic) IBOutlet UIButton *restDateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *restTimeSelect;
@property (weak, nonatomic) IBOutlet UITextField *remarkText;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property int dateTag;
@property (strong, nonatomic) SMAttendTxModel* editModel;

@property (weak, nonatomic) IBOutlet UIView *auditOpinionPanelView;
@property (weak, nonatomic) IBOutlet UILabel *opinion1Label;
@property (weak, nonatomic) IBOutlet UILabel *opinion2Label;

@property float selftop;

@end

@implementation SMEditTxPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showEditTxPickViewWithFinishBlock:(void(^)(SMAttendTxModel *model, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)editData:(SMAttendTxModel*) model
{
    [_removeButton setHidden:model == nil];
    if (model == nil){
        _editModel = [[SMAttendTxModel alloc] init];
    }
    else{
        _editModel = model;
    }
    
    if (IS_STRING_EMPTY(_editModel.extraworkDate)){
        _editModel.extraworkDate = [UIUtil getDateString:[NSDate date]];
    }
    if (IS_STRING_EMPTY(_editModel.restDate)){
        _editModel.restDate = [UIUtil getDateString:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
    }
    
    [_remarkText resignFirstResponder];
    
    [_extraworkDateButton setTitle:_editModel.extraworkDate forState:UIControlStateNormal];
    [_restDateButton setTitle:_editModel.restDate forState:UIControlStateNormal];
    [_remarkText setText:_editModel.remark];
    
    [_datePicker removeTarget:self action:@selector(dataChanged:) forControlEvents:UIControlEventValueChanged];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [_datePickerView setHidden:YES];
    
    if ([_editModel.extraworkTime isEqualToString:@"上午"]){
        _extraworkTimeSelect.selectedSegmentIndex = 0;
    }
    else if ([_editModel.extraworkTime isEqualToString:@"下午"]){
        _extraworkTimeSelect.selectedSegmentIndex = 1;
    }
    else if ([_editModel.extraworkTime isEqualToString:@"全天"]){
        _extraworkTimeSelect.selectedSegmentIndex = 2;
    }
    
    if ([_editModel.restTime isEqualToString:@"上午"]){
        _restTimeSelect.selectedSegmentIndex = 0;
    }
    else if ([_editModel.restTime isEqualToString:@"下午"]){
        _restTimeSelect.selectedSegmentIndex = 1;
    }
    else if ([_editModel.restTime isEqualToString:@"全天"]){
        _restTimeSelect.selectedSegmentIndex = 2;
    }
    
    self.remarkText.delegate = self;
    self.dateTag = 0;
    
    
    
    if ([_editModel canEdit]){
        [_auditOpinionPanelView setHidden:YES];
    }
    else{
        [_auditOpinionPanelView setHidden:NO];
        if ([_editModel.peroson length] > 0){
            [_opinion1Label setText:[[_editModel.peroson stringByAppendingString:@":"] stringByAppendingString:_editModel.opinion]];
        }
        else{
            [_opinion1Label setText:@""];
        }
        [_opinion2Label setText:@""];
    }
    
    
}

-(BOOL)dataCheck
{
    int workselectidx = [_extraworkTimeSelect selectedSegmentIndex];
    int restselectidx = [_restTimeSelect selectedSegmentIndex];
    if (workselectidx == 2 && restselectidx != 2){
        [PROMPT_VIEW showMessage:@"调休全天必须一致"];
        return false;
    }
    if (restselectidx == 2 && workselectidx != 2){
        [PROMPT_VIEW showMessage:@"调休全天必须一致"];
        return false;
    }
    
    return true;
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
    int offset = self.top + self.height - frame.origin.y - frame.size.height - 216.0 - 38;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frame =CGRectMake(0, self.selftop, self.frame.size.width, self.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_remarkText resignFirstResponder];
    [_datePickerView setHidden:YES];
}

-(void)dateChanged:(id)sender{
    if (self.dateTag == 0){
        [_extraworkDateButton setTitle: [UIUtil getDateString:[_datePicker date]] forState:UIControlStateNormal];
        _editModel.extraworkDate = [[_extraworkDateButton titleLabel] text];
    }
    else if (self.dateTag == 1){
        [_restDateButton setTitle: [UIUtil getDateString:[_datePicker date]] forState:UIControlStateNormal];
        _editModel.restDate = [[_restDateButton titleLabel] text];
    }
} 



- (IBAction)closeBtnClick:(id)sender {
    [_remarkText resignFirstResponder];
    [_datePickerView setHidden:YES];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_editModel, -1, nil);
        }
    }];
}

- (IBAction)buttonDidClicked:(id)sender {
    if ([self dataCheck] ==false){
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_editModel, [sender tag], nil);
        }
    }];
}
-(void)collectdata{
    _editModel.extraworkDate = [[_extraworkDateButton titleLabel] text];
    _editModel.extraworkTime = [_extraworkTimeSelect titleForSegmentAtIndex:[_extraworkTimeSelect selectedSegmentIndex]];
    _editModel.restDate = [[_restDateButton titleLabel] text];
    _editModel.restTime = [_restTimeSelect titleForSegmentAtIndex:[_restTimeSelect selectedSegmentIndex]];
    _editModel.remark = [_remarkText text];
}

- (IBAction)selectWorkDateBtnClicked:(id)sender {
    BOOL sametag = self.dateTag == [sender tag];
    if (sametag){
        if (_datePickerView.tag == 1){
            [_datePickerView setHidden:YES];
            _datePickerView.tag = 0;
        }
        else{
            [_datePickerView setHidden:NO];
            _datePickerView.tag = 1;
        }
    }
    else{
        [_datePickerView setHidden:NO];
        _datePickerView.tag = 1;
    }
    
    self.dateTag = [sender tag];
    if (self.dateTag == 0){
        [_datePicker setDate: [NSDate dateWithString:_editModel.extraworkDate formate:@"yyyy-MM-dd"]];
    }
    else if (self.dateTag == 1){
        [_datePicker setDate: [NSDate dateWithString:_editModel.restDate formate:@"yyyy-MM-dd"]];
    }
}

- (IBAction)restDateValueChanged:(id)sender {
    if ([self dataCheck] == false){
        return;
    }
    _editModel.restTime = [_restTimeSelect titleForSegmentAtIndex:[_restTimeSelect selectedSegmentIndex]];
}

- (IBAction)workDateValueChanged:(id)sender {
    if ([self dataCheck] == false){
        return;
    }
    _editModel.extraworkTime = [_extraworkTimeSelect titleForSegmentAtIndex:[_extraworkTimeSelect selectedSegmentIndex]];
}

@end
