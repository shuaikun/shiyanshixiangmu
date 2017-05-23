//
//  SMAuditTxPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-23.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAuditTxPickView.h"

@interface SMAuditTxPickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMAttendTxModel *model, int optype, NSString *opinion);

@property (weak, nonatomic) IBOutlet UILabel *staffnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraworkLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITextField *optionText;


@property (strong, nonatomic) SMAttendTxModel* editModel;
@property float selftop;

@end

@implementation SMAuditTxPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
} 


- (void)showTxPickViewWithFinishBlock:(void(^)(SMAttendTxModel *model, int optype, NSString *opinion))finishBlock
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
    _editModel = model;
    
    [_staffnameLabel setText:_editModel.staffName];
    [_extraworkLabel setText:_editModel.extrawork];
    [_restLabel setText:_editModel.rest];
    [_remarkLabel setText:_editModel.remark];
    [_optionText setText:_editModel.opinion];
    
    _optionText.delegate = nil;
    _optionText.delegate = self;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_optionText resignFirstResponder];
}



- (IBAction)closeBtnClick:(id)sender {
    
    [_optionText resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_editModel, -1, _optionText.text);
        }
    }];
}

- (IBAction)buttonDidClicked:(id)sender {
   [_optionText resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            
            _editModel.opinion = _optionText.text;
            
            _finishPickBlock(_editModel, [sender tag], _optionText.text);
        }
    }];
}




@end
