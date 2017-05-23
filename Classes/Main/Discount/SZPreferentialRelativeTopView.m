//
//  SZPreferentialRelativeTopView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZPreferentialRelativeTopView.h"

@interface SZPreferentialRelativeTopView()

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation SZPreferentialRelativeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)ifCoupon:(BOOL)isCoupon
{
    if(isCoupon){
        _titleLabel.text = @"优惠券";
        [_rightButton setImage:[UIImage imageNamed:@"SZ_Picture_Normal.png"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"SZ_Picture_Tapped.png"] forState:UIControlStateHighlighted];
    }
    else{
        _titleLabel.text = @"会员卡";
        [_rightButton setImage:[UIImage imageNamed:@"SZ_VIP_Normal.png"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"SZ_VIP_Tapped.png"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)onBackButtonClicked:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(preferentialRelativeTopViewBackButtonClicked)]){
        [_delegate preferentialRelativeTopViewBackButtonClicked];
    }
}

- (IBAction)onShareButtonClicked:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(preferentialRelativeTopViewShareButtonClicked)]){
        [_delegate preferentialRelativeTopViewShareButtonClicked];
    }
}

- (IBAction)onShowPictureButtonClicked:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(preferentialRelativeTopViewShowPictureButtonClicked)]){
        [_delegate preferentialRelativeTopViewShowPictureButtonClicked];
    }
}


@end
