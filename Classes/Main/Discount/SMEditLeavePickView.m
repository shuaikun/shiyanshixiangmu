//
//  SMEditLeavePickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-21.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMEditLeavePickView.h"

@interface SMEditLeavePickView ()
@property (nonatomic, copy) void(^finishPickBlock)(SMAttendLeaveModel *model, int optype, NSString *opinion);

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fromDateButton;
@property (weak, nonatomic) IBOutlet UIButton *toDateButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@property (weak, nonatomic) IBOutlet UITextField *opinionLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dataPickerView;
@property (weak, nonatomic) IBOutlet UIButton *dataPickerCloseButton;
@property (weak, nonatomic) IBOutlet UITextField *sumTimeText;

@property (weak, nonatomic) IBOutlet UIView *selectTypePickView;
@property (weak, nonatomic) IBOutlet UIPickerView *selectTypePicker;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;


@property (strong, nonatomic) SMAttendLeaveModel *editModel;
@property int dateTag;
@property float selftop;
@property (strong, nonatomic) NSArray *typePickerData;

@property (weak, nonatomic) IBOutlet UIView *auditOpinionPanelView;
@property (weak, nonatomic) IBOutlet UILabel *opinion1Label;
@property (weak, nonatomic) IBOutlet UILabel *opinion2Label;


@end

@implementation SMEditLeavePickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)closeButtonClick:(id)sender {
    [_opinionLabel resignFirstResponder];
    [_sumTimeText resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_editModel, -1, _opinionLabel.text);
        }
    }];
}
- (IBAction)selectTypeButtonClick:(id)sender {
    if (_selectTypePickView.tag == 0){
        [_selectTypePickView setHidden:NO];
        _selectTypePickView.tag = 1;
    }
    else if (_selectTypePickView.tag == 1)
    {
        [_selectTypePickView setHidden:YES];
        _selectTypePickView.tag = 0;
    }
    
}
- (IBAction)fromDateBtnClicked:(id)sender {
    self.dateTag = 0;
    [_dataPickerView setHidden:NO];
    [_dataPickerCloseButton setHidden:NO];
    [_datePicker setDate:[NSDate dateWithString:_editModel.starttime formate:@"yyyy-MM-dd hh:mm"] animated:YES];
}
- (IBAction)toDateBtnClicked:(id)sender {
    self.dateTag = 1;
    [_dataPickerView setHidden:NO];
    [_dataPickerCloseButton setHidden:NO];
    [_datePicker setDate:[NSDate dateWithString:_editModel.endtime formate:@"yyyy-MM-dd hh:mm"] animated:YES];
}
- (IBAction)confirmButtonClicked:(id)sender {
    
    if (![self checkData]){
        return;
    }
    [_opinionLabel resignFirstResponder];
    [_sumTimeText resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_editModel, [sender tag], _opinionLabel.text);
        }
    }];
}
- (IBAction)closeDatePickBtnClick:(id)sender {
    [_dataPickerView setHidden:YES];
    [_dataPickerCloseButton setHidden:YES];
    [_sumTimeText resignFirstResponder];
}

- (void)showEditLeavePickViewWithFinishBlock:(void(^)(SMAttendLeaveModel *model, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)editLeaveData:(SMAttendLeaveModel*) model
{
    [_removeButton setHidden:model == nil];
    if (model == nil){
        _editModel = [[SMAttendLeaveModel alloc] init];
    }
    else{
        _editModel = model;
    }
    
    if (IS_STRING_EMPTY(_editModel.starttime)){
        _editModel.starttime = [UIUtil getTimeString:[NSDate date]];
    }
    if (IS_STRING_EMPTY(_editModel.endtime)){
        _editModel.endtime = [UIUtil getTimeString:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
    }
    if (IS_STRING_EMPTY(_editModel.type)){
        _editModel.type = @"公假";
    }
    
    if (self.typePickerData == nil){
        NSArray *array = [[NSArray alloc] initWithObjects:@"公假", @"病假", @"事假", @"公派", @"婚假", @"丧假", @"产假", @"陪护假", @"工伤假", @"带薪年假", @"其他", nil];
        self.typePickerData = array;
    }
    
    
    _opinionLabel.delegate = nil;
    _sumTimeText.delegate = nil;
    _selectTypePicker.delegate = nil;
    
    _opinionLabel.delegate = self;
    _sumTimeText.delegate = self;
    _selectTypePicker.delegate = self;
    
    
    [_fromDateButton setTitle:_editModel.starttime forState:UIControlStateNormal];
    [_toDateButton setTitle:_editModel.endtime forState:UIControlStateNormal];
    [_opinionLabel setText:_editModel.reason];
    [_sumTimeText setText:_editModel.sumtime];
    [_typeButton setTitle:_editModel.type forState:UIControlStateNormal];
    
    
    [_dataPickerView setHidden:YES];
    [_dataPickerCloseButton setHidden:YES];
    [_selectTypePickView setHidden:YES];
    
    if ([_editModel canEdit]){
        [_dataPickerCloseButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_datePicker removeTarget:self action:@selector(dataChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [_auditOpinionPanelView setHidden:YES];
    }
    else{
        [_auditOpinionPanelView setHidden:NO];
        if ([_editModel.oneperson length] > 0){
            [_opinion1Label setText:[[_editModel.oneperson stringByAppendingString:@":"] stringByAppendingString:_editModel.oneopinion]];
        }
        else{
            [_opinion1Label setText:@""];
        }
        if ([_editModel.twoperson length] > 0){
            [_opinion2Label setText:[[_editModel.twoperson stringByAppendingString:@":"] stringByAppendingString:_editModel.twoopinion]];
        }
        else{
            [_opinion2Label setText:@""];
        }
        
    }

    
    
}
-(void)collectdata{
    [_sumTimeText resignFirstResponder];
    
    _editModel.reason = _opinionLabel.text;
    _editModel.startTime = [[_fromDateButton titleLabel] text];
    _editModel.endTime = [[_toDateButton titleLabel] text];
    _editModel.type = [[_typeButton titleLabel] text];
    _editModel.sumTime = [_sumTimeText text];
    
}

-(BOOL)checkData {

    if ([[_sumTimeText text] length] == 0){
        [PROMPT_VIEW showMessage:@"请输入请假时间，如：2天或2小时"];
        return false;
    }
    if (![_sumTimeText.text isEndWithString:@"天"] && ![_sumTimeText.text isEndWithString:@"小时"]){
        [PROMPT_VIEW showMessage:@"请假时间的单位必须是天或小时"];
        return false;
    }
    if ([_opinionLabel.text length] == 0){
        [PROMPT_VIEW showMessage:@"请输入请假原因"];
        return false;
    }
    
    return true;
}



-(void)dateChanged:(id)sender{
    if (self.dateTag == 0){
        [_fromDateButton setTitle: [UIUtil getTimeString:[_datePicker date]] forState:UIControlStateNormal];
    }
    else if (self.dateTag == 1){
        [_toDateButton setTitle: [UIUtil getTimeString:[_datePicker date]] forState:UIControlStateNormal];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_selectTypePickView setHidden:YES];
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
    [_opinionLabel resignFirstResponder];
    [_sumTimeText resignFirstResponder];
    [_selectTypePickView setHidden:YES];
}



#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self typePickerData] count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self typePickerData] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_typeButton setTitle:[[self typePickerData] objectAtIndex:row] forState:UIControlStateNormal];
}




@end
