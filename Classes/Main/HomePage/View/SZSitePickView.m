//
//  SZSitePickView.m
//  iTotemFramework
//
//  Created by Grant on 14-5-8.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZSitePickView.h"
#import "AppDelegate.h"

@interface SZSitePickView ()
@property (nonatomic, copy) void(^finishPickBlock)(NSString *city);
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@end

@implementation SZSitePickView

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

- (void)showSitePickViewWithFinishBlock:(void(^)(NSString *site))finishBlock
{
    NSString *city = [[UserManager sharedUserManager] city];
    if (city == nil) {
        [_closeBtn setHidden:YES];
    }else
    {
        [_closeBtn setHidden:NO];
    }
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}

- (IBAction)stieBtnDidClicked:(UIButton *)siteBtn {
    NSString *city = siteBtn.titleLabel.text;
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UserManager sharedUserManager] setCity:city];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(city);
        }
    }];
}

- (IBAction)closeBtnDidClicked:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            NSString *city = [[UserManager sharedUserManager] city];
            _finishPickBlock(city);
        }
    }];
}


@end
