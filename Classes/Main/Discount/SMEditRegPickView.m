//
//  SMEditRegPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-19.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMEditRegPickView.h"

@interface SMEditRegPickView ()
@property (nonatomic, copy) void(^finishPickBlock)(SMAttendRegModel *regModel, int optype, NSString *opinion);
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *datetimeLablel;
@property (weak, nonatomic) IBOutlet UITextField *opinionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ampmSelectButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *updownSelectButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dataPickerView;
@property (weak, nonatomic) IBOutlet UIButton *dataPickerCloseButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UIView *auditOpinionPanelView;
@property (weak, nonatomic) IBOutlet UILabel *opinion1Label;
@property (weak, nonatomic) IBOutlet UILabel *opinion2Label;



@property (strong, nonatomic) SMAttendRegModel *editRegModel;

@property float selftop;

@end

@implementation SMEditRegPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showEditRegPickViewWithFinishBlock:(void(^)(SMAttendRegModel *regModel, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)editRegData:(SMAttendRegModel*) regModel
{
    [_removeButton setHidden:regModel == nil];
    _editRegModel = nil;
    if (regModel == nil){
        _editRegModel = [[SMAttendRegModel alloc] init];
    }
    else{
        _editRegModel = regModel;
    }
    
    if (IS_STRING_EMPTY(_editRegModel.date)){
        _editRegModel.date = [UIUtil getDateString:[NSDate date]];
    }
    
    //todo show detail ...
    [[self datetimeLablel] setTitle:_editRegModel.date forState:UIControlStateNormal];
    [_opinionLabel setText:_editRegModel.reason];
    [_datetimeLablel setTitle:_editRegModel.date forState:UIControlStateNormal];
    
    _opinionLabel.delegate = self;
    
    [_dataPickerView setHidden:YES];
    [_dataPickerCloseButton setHidden:YES];
    
    if ([_editRegModel canEdit]){
        [_dataPickerCloseButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_datePicker removeTarget:self action:@selector(dataChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [_auditOpinionPanelView setHidden:YES];
    }
    else{
        [_auditOpinionPanelView setHidden:NO];
        if ([_editRegModel.oneperson length] > 0){
            [_opinion1Label setText:[[_editRegModel.oneperson stringByAppendingString:@":"] stringByAppendingString:_editRegModel.oneopinion]];
        }
        else{
            [_opinion1Label setText:@""];
        }
        [_opinion2Label setText:@""];
            
    }
    
}


-(void)dateChanged:(id)sender{
    [_datetimeLablel setTitle: [UIUtil getDateString:[_datePicker date]] forState:UIControlStateNormal];
    _editRegModel.date = _datetimeLablel.titleLabel.text;
}


- (IBAction)closeBtnClick:(id)sender {
    [_opinionLabel resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_editRegModel, -1, _opinionLabel.text);
        }
    }];
}

- (IBAction)buttonDidClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_editRegModel, [sender tag], _opinionLabel.text);
        }
    }];
}


-(void)collectdata{
    _editRegModel.reason = _opinionLabel.text;
    _editRegModel.date = _datetimeLablel.titleLabel.text;
    _editRegModel.time = [[_ampmSelectButton titleForSegmentAtIndex:[_ampmSelectButton selectedSegmentIndex]] stringByAppendingString:[_updownSelectButton titleForSegmentAtIndex:[_updownSelectButton selectedSegmentIndex]]];
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
    [_opinionLabel resignFirstResponder];
    [[self dataPickerView] setHidden:YES];
    [self dataPickerView].tag = 0;
}
- (IBAction)datetimeButton:(id)sender {
    
    if ([_editRegModel canEdit]){
        if ([[self dataPickerView] tag] == 0){
            [[self dataPickerView] setHidden:NO];
            [self dataPickerView].tag = 1;
            [_datePicker setDate:[NSDate dateWithString:_editRegModel.date formate:@"yyyy-MM-dd"] animated:YES];
        }
        else{
            [[self dataPickerView] setHidden:YES];
            [self dataPickerView].tag = 0;
        }
        
        [_dataPickerCloseButton setHidden:YES];
        [_dataPickerCloseButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}
- (IBAction)datePickerCloseButtonClicked:(id)sender {
    if ([_editRegModel canEdit]){
        [[self dataPickerView] setHidden:YES];
        [_dataPickerCloseButton setHidden:YES];
        [_datetimeLablel setTitle:[UIUtil getDateString:[_datePicker date]] forState:UIControlStateNormal];
    }
}


@end
