//
//  SMNewsPickView.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsPickView.h"
#import "AppDelegate.h"

@interface SMNewsPickView ()
@property (nonatomic, copy) void(^finishPickBlock)(NSString *news);
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@end

@implementation SMNewsPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showNewsPickViewWithFinishBlock:(void(^)(NSString *news))finishBlock
{
    NSString *city = [[UserManager sharedUserManager] news];
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

- (IBAction)newsBtnDidClicked:(UIButton *)siteBtn {
    NSString *news = siteBtn.titleLabel.text;
    news = [news stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UserManager sharedUserManager] setNews:news];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(news);
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
            NSString *news = [[UserManager sharedUserManager] news];
            _finishPickBlock(news);
        }
    }];
}


@end
