//
//  SMRptZBNextWeekItemPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-10.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBNextWeekItemPickView.h"

@interface SMRptZBNextWeekItemPickView()
@property (nonatomic, copy) void(^finishPickBlock)(SMRptZBNextweekItemModel *model, int optype, NSString *opinion);

@property (weak, nonatomic) IBOutlet UITextView *workcontentTextView;
@property (weak, nonatomic) IBOutlet UIButton *timenodeButton;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UITextView *personTextView;
@property (weak, nonatomic) IBOutlet UITextView *punishmentTextView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UITextView *measuresTextView;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) SMRptZBNextweekItemModel *model;

@property (strong, nonatomic) NSMutableArray *levelData;

@property float selftop;

@end

@implementation SMRptZBNextWeekItemPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
- (IBAction)textViewChanged:(id)sender {
    [self clearPickerView];
    
    [_personTextView setHidden:YES];
    [_punishmentTextView setHidden:YES];
    [_remarkTextView setHidden:YES];
    if ([sender selectedSegmentIndex] == 0){
        [_personTextView setHidden:NO];
    }
    else if ([sender selectedSegmentIndex] == 1){
        [_punishmentTextView setHidden:NO];
    }
    else if ([sender selectedSegmentIndex] == 2){
        [_remarkTextView setHidden:NO];
    }
    
}
- (IBAction)dateSelectDidClicked:(id)sender {
    [self clearPickerView];
    [_datePicker setHidden:NO];
    [_picker setHidden:YES];
    [_pickerView setHeight:_datePicker.height];
    _datePicker.top = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.top = weakSelf.height - _pickerView.height;
        
    }];
}
- (IBAction)levelSelectDidClicked:(id)sender {
    
    if (_levelData == nil){
        _levelData = [[NSMutableArray alloc] init];
        [self.levelData addObject:@"很重要很紧急"];
        [self.levelData addObject:@"很重要不紧急"];
        [self.levelData addObject:@"不重要很紧急"];
        [self.levelData addObject:@"不重要不紧急"];
        
        [_picker reloadAllComponents];
    }
    
    
    [self clearPickerView];
    [_datePicker setHidden:YES];
    [_picker setHidden:NO];
    [_pickerView setHeight:_picker.height];
    _picker.top = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.top = weakSelf.height - _pickerView.height;
    }];
    
}
- (IBAction)dateChanged:(id)sender {
    [_timenodeButton setTitle: [UIUtil getDateString:[sender date]] forState:UIControlStateNormal];
    _model.timenode = _timenodeButton.titleLabel.text;
}

-(void)collectdata{
    _model.workcontent = [self.workcontentTextView text];
    _model.level = _levelButton.titleLabel.text;
    _model.timenode = _timenodeButton.titleLabel.text;
    _model.measures = _measuresTextView.text;
    _model.person = _personTextView.text;
    _model.punishment = _punishmentTextView.text;
    _model.remark = _remarkTextView.text;
    
}


- (void)showReportZBNextWeekItemPickViewWithFinishBlock:(void(^)(SMRptZBNextweekItemModel *model, int optype, NSString *opinion))finishBlock
{
    self.workcontentTextView.delegate = nil;
    self.personTextView.delegate=nil;
    self.workcontentTextView.delegate = self;
    self.personTextView.delegate = self;
    
    self.measuresTextView.delegate = nil;
    self.measuresTextView.delegate= self;
    
    self.punishmentTextView.delegate = nil;
    self.punishmentTextView.delegate = self;
    
    self.remarkTextView.delegate = nil;
    self.remarkTextView.delegate = self;
    
    self.picker.delegate = nil;
    self.picker.delegate = self;
    
    self.finishPickBlock = finishBlock;
    
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)setData:(SMRptZBNextweekItemModel*) model
{
    if (model == nil){
        _model = [[SMRptZBNextweekItemModel alloc] init];
        _model.id = @"";
        _model.timenode = [UIUtil getDateString:[NSDate new]];
    }
    else{
        _model = model;
    }
    
    _workcontentTextView.text = _model.workcontent;
    _measuresTextView.text = _model.measures;
    [_timenodeButton setTitle:_model.timenode forState:UIControlStateNormal];
    _personTextView.text = _model.person;
    _punishmentTextView.text = _model.punishment;
    _remarkTextView.text = _model.remark;
    
    _pickerView.top = self.bottom;
    
    [_remarkTextView setHidden:YES];
    [_punishmentTextView setHidden:YES];
    [_personTextView setHidden:NO];
    
    [_datePicker setDate:[NSDate  dateWithString:_model.timenode formate:@"yyyy-MM-dd"]];
    
}


-(void)clearPickerView
{
    if (_workcontentTextView != nil){
        [self.workcontentTextView endEditing:YES];
        [self.remarkTextView endEditing:YES];
        [self.measuresTextView endEditing:YES];
        [self.punishmentTextView endEditing:YES];
        [self.personTextView endEditing:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.top = self.bottom;
    }];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    
    [self clearPickerView];
    
    [super touchesBegan:touches withEvent:event];
}

/* -----------------------------------------------------------------------------
    picker for level ....
 -----------------------------------------------------------------------------*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self levelData] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self levelData] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.levelButton setTitle:[[self levelData] objectAtIndex:row] forState:UIControlStateNormal];
    _model.level = self.levelButton.titleLabel.text;
}

@end
