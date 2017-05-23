//
//  SZMerchantDiscounuCellView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDiscounuCellView.h"

@implementation SZMerchantDiscounuCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    CGRect bounds = self.bounds;
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 20, 20)];
        _imageView.image = ImageNamed(@"SZ_Mine_Card_Icon.png");
        [self addSubview:_imageView];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 12, 225, 21)];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10, bounds.size.height-1, bounds.size.width-10, 1)];
        _bottomLine.backgroundColor = RGBCOLOR(222, 222, 222);
        [self addSubview:_bottomLine];
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = self.bounds;
        [_clickBtn addTarget:self action:@selector(handleClickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(290, 15, 10, 14)];
        _arrowView.image = ImageNamed(@"btn_arrow.png");
        [self addSubview:_arrowView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor whiteColor];
    CGRect bounds = self.bounds;
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 20, 20)];
        _imageView.image = ImageNamed(@"SZ_Mine_Card_Icon.png");
        [self addSubview:_imageView];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 12, 225, 21)];

        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10, bounds.size.height-1, bounds.size.width-10, 1)];
        _bottomLine.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_bottomLine];
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = self.bounds;
        [_clickBtn addTarget:self action:@selector(handleClickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(290, 15, 10, 14)];
        _arrowView.image = ImageNamed(@"btn_arrow.png");
        [self addSubview:_arrowView];
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

- (IBAction)handleClickBtnClick:(id)sender {
    if (self.click!=nil) {
        self.click();
    }
}
@end
