//
//  SZMerchantDetailAroundCellView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailAroundCellView.h"

@interface SZMerchantDetailAroundCellView()

@property (nonatomic, strong) UILabel *label;
@end

@implementation SZMerchantDetailAroundCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(150, 150, 150);
        CGRect bounds = self.bounds;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, bounds.size.width-2, bounds.size.height-2)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor whiteColor];
        _label.userInteractionEnabled = YES;
        
        _label.font = [UIFont systemFontOfSize:13.f];
        _label.textColor = [UIColor darkGrayColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        [_label addGestureRecognizer:tap];
        [self addSubview:_label];
    }
    return self;
}

- (void)tap:(id)sender
{
    if (self.click!=nil) {
        self.click();
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    _label.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
