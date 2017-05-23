//
//  SZChangeImageView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZChangeImageView.h"

@interface SZChangeImageView()

@property (strong, nonatomic) UIControl *bgControl;

- (IBAction)onTakePictureButtonClicked:(id)sender;
- (IBAction)onChoosePictureButtonClicked:(id)sender;
- (IBAction)onDismissButtonClicked:(id)sender;

@end

@implementation SZChangeImageView

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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    _bgControl = [[UIControl alloc] initWithFrame:[[[UIApplication sharedApplication].delegate window] bounds]];
    _bgControl.backgroundColor = [UIColor blackColor];
    _bgControl.alpha = 0.5;
}

- (void)showInView:(UIView *)superView
{
    [superView addSubview:_bgControl];
    [superView addSubview:self];
    [UIUtil addAnimationShakeInView:self minShowScal:0.85 maxShowScal:1.02 middleShowScal:0.98 delegate:nil];
}

- (void)dismiss
{
    [_bgControl removeFromSuperview];
    [UIUtil addAnimationScal:self toPoint:self.center lightState:NO delegate:self startSelector:nil stopSelector:@selector(removeFromSuperview) scaleNumber:0.9 duraion:0.3];
}

- (IBAction)onTakePictureButtonClicked:(id)sender
{
    NSLog(@"take");
    if(_delegate && [_delegate respondsToSelector:@selector(changeImageViewTakePictureButtonClicked)]){
        [_delegate changeImageViewTakePictureButtonClicked];
    }
    [self dismiss];
}

- (IBAction)onChoosePictureButtonClicked:(id)sender
{
    NSLog(@"choose");
    if(_delegate && [_delegate respondsToSelector:@selector(changeImageViewChoosePictureButtonClicked)]){
        [_delegate changeImageViewChoosePictureButtonClicked];
    }
    [self dismiss];
}

- (IBAction)onDismissButtonClicked:(id)sender
{
    NSLog(@"dismiss");
    [self dismiss];
}

@end
