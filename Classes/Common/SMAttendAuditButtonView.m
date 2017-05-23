//
//  SMAttendAuditButtonView.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendAuditButtonView.h"
#import "UserManager.h"

@interface SMAttendAuditButtonView()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;


@end

@implementation SMAttendAuditButtonView
- (IBAction)btnDidClicked:(id)sender {
    
    int tag = [sender tag];
    [self setSelected:tag];
    
    if(_delegate && [_delegate respondsToSelector:@selector(SMAttendAuditButtonViewButtonTapped:)]){
        [_delegate SMAttendAuditButtonViewButtonTapped:tag];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initTopButton];
}

- (void)setSelected:(int)idx
{
    int tag = idx;
    BOOL is0 = tag == kTagKaoQinOneChoiceMyReg;
    BOOL is1 = tag == kTagKaoQinOneChoiceMyLeave;
    BOOL is2 = tag == kTagKaoQinOneChoiceAuditReg;
    bool is3 = tag == kTagKaoQinOneChoiceAuditLeave;
    [_btn1 setSelected:is0];
    [_btn2 setSelected:is1];
    [_btn3 setSelected:is2];
    [_btn4 setSelected:is3];
}


-(void) initTopButton
{
    self.btn1.tag = kTagKaoQinOneChoiceMyReg;
    self.btn2.tag = kTagKaoQinOneChoiceMyLeave;
    self.btn3.tag = kTagKaoQinOneChoiceAuditReg;
    self.btn4.tag = kTagKaoQinOneChoiceAuditLeave;
    
    [self.btn1 setTitleColor:[CommonUtils colorWithHexString:@"#0DADDE"] forState:UIControlStateSelected];
    [self.btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[CommonUtils colorWithHexString:@"#0DADDE"] forState:UIControlStateSelected];
    [self.btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn3 setTitleColor:[CommonUtils colorWithHexString:@"#0DADDE"] forState:UIControlStateSelected];
    [self.btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn4 setTitleColor:[CommonUtils colorWithHexString:@"#0DADDE"] forState:UIControlStateSelected];
    [self.btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.btn1 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"SM_BTN_SELECT.png"] forState:UIControlStateSelected];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"SM_BTN_SELECT.png"] forState:UIControlStateSelected];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"SM_BTN_SELECT.png"] forState:UIControlStateSelected];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"SM_BTN_SELECT.png"] forState:UIControlStateSelected];
    
    //[self setSelected: [[UserManager sharedUserManager] attendType]];
}



@end
