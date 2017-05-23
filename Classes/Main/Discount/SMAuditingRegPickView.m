//
//  SMAuditingRegPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-8.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAuditingRegPickView.h"

@interface SMAuditingRegPickView ()
@property (nonatomic, copy) void(^finishPickBlock)(SMAttendRegModel *regModel, int optype, NSString *opinion);
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLablel;
@property (weak, nonatomic) IBOutlet UILabel *staffnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *opinionLabel;


@property (strong, nonatomic) SMAttendRegModel *auditingRegModel;

@property float selftop;

@end

@implementation SMAuditingRegPickView



- (IBAction)closeBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_auditingRegModel, -1, _opinionLabel.text);
        }
    }];
}

- (IBAction)auditingBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_auditingRegModel, [sender tag], _opinionLabel.text);
        }
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
}

- (void)showAuditingRegPickViewWithFinishBlock:(void(^)(SMAttendRegModel *regModel, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)auditingRegData:(SMAttendRegModel*) regModel
{
    _auditingRegModel = regModel;
    
    //todo show detail ...
    [_staffnameLabel setText:regModel.staffname];
    [_deptnameLabel setText:regModel.deptname];
    [_datetimeLablel setText:[regModel.date stringByAppendingFormat:@" %@",regModel.time]];
    [_reasonLabel setText:regModel.reason];
    [_statusLabel setText:regModel.status];
    
    _opinionLabel.delegate = self;
}


@end
