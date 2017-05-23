//
//  SZBaseTopView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseTopView.h"

@implementation SZBaseTopView

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

- (IBAction)onBackButtonClicked:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(baseTopViewBackButtonClicked)]){
        [_delegate baseTopViewBackButtonClicked];
    }
}

- (IBAction)onRightButtonClicked:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(baseTopViewRightButtonClicked)]){
        [_delegate baseTopViewRightButtonClicked];
    }
}

@end
