//
//  SMAuditingLeavePickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAuditingLeavePickView.h"

@interface SMAuditingLeavePickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMAttendLeaveModel *regModel, int optype, NSString *opinion);
@property (strong, nonatomic) SMAttendLeaveModel *auditingLeaveModel;

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLablel;
@property (weak, nonatomic) IBOutlet UILabel *staffnameLabel; 
@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *opinionLabel;

@property float selftop;

@end

@implementation SMAuditingLeavePickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)closeBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_auditingLeaveModel, -1, _opinionLabel.text);
        }
    }];
}

- (IBAction)auditingBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_auditingLeaveModel, [sender tag], _opinionLabel.text);
        }
    }];
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


- (void)showAuditingLeavePickViewWithFinishBlock:(void(^)(SMAttendLeaveModel *regModel, int optype, NSString *opinion))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

-(void)auditingLeaveData:(SMAttendLeaveModel*) model
{
    _auditingLeaveModel = model;
    
    //todo show detail ...
    [_staffnameLabel setText:model.staffname];
    [_deptnameLabel setText:model.deptname];
    [_datetimeLablel setText:[model.startTime stringByAppendingFormat:@" - %@",model.endTime]];
    [_reasonLabel setText:model.reason];
    [_statusLabel setText:model.status];
    [_typeLabel setText:model.type];
    [_sumTimeLabel setText:model.sumTime];
    //[_opinionLabel setText:model.oneopinion];
    
    
    _opinionLabel.delegate = self;
     
}

@end
