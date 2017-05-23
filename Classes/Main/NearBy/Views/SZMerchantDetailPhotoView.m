//
//  SZMerchantDetailPhotoView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailPhotoView.h"
#import "SZMerchantDetailPicView.h"
#import "SZNearByMerchantDetailModel.h"
#import "SZNearByProductPicModel.h"
@interface SZMerchantDetailPhotoView()
{
    NSMutableArray *pics;
}

@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIButton *moreBtn;
- (void)handleMoreBtnClicks:(id)sender;
@end

@implementation SZMerchantDetailPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pics:(NSMutableArray *)products
{
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        pics = [[NSMutableArray alloc]init];
        if ([products count]==0) {
            self.height = 0;
        }else{
            UIView *bgColorview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 33)];
            bgColorview.backgroundColor = RGBCOLOR(248, 248, 248);
            [self addSubview:bgColorview];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 305, 33)];
            label.backgroundColor = RGBCOLOR(248, 248, 248);
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = @"产品图册";
            [self addSubview:label];
            for (int i = 0; i<[products count]&&i<2; i++) {
                SZNearByProductPicModel *picModel = [products objectAtIndex:i];
                SZMerchantDetailPicView *pic = [[SZMerchantDetailPicView alloc]initWithFrame:CGRectMake(20+149*i, 48, 131, 104)];
                pic.pic = picModel;
                pic.click = ^(SZNearByProductPicModel *pic){
                    if (self.picClick!=nil) {
                        self.picClick(pic);
                    }
                };
                [self addSubview:pic];
                [pics addObject:pic];
            }
            _moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 163, 320, 40)];
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
            topLine.backgroundColor = RGBCOLOR(222, 222, 222);
            UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
            bottomLine.backgroundColor = RGBCOLOR(222, 222, 222);
            _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _moreBtn.frame = CGRectMake(0, 1, 320, 38);
            [_moreBtn setTitleColor:RGBCOLOR(42, 172, 226) forState:UIControlStateNormal];
            [_moreBtn setTitle:@"十查看全部10张照片" forState:UIControlStateNormal];
            _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [_moreBtn setBackgroundColor:[UIColor whiteColor]];
            [_moreBtn addTarget:self action:@selector(handleMoreBtnClicks:) forControlEvents:UIControlEventTouchUpInside];
            [_moreView addSubview:topLine];
            [_moreView addSubview:bottomLine];
            [_moreView addSubview:_moreBtn];
            [self addSubview:_moreView];
        }
    }
    return self;
}

- (void)handleMoreBtnClicks:(id)sender
{
    NSLog(@"---");
    if (self.moreClick!=nil) {
        self.moreClick();
    }
}

- (void)setMoreNumber:(NSString *)moreNumber
{
    _moreNumber = [moreNumber copy];
    [_moreBtn setTitle:[NSString stringWithFormat:@"十查看全部%@张照片",_moreNumber] forState:UIControlStateNormal];
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
