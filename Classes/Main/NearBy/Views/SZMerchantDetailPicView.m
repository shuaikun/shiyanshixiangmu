//
//  SZMerchantDetailPicView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailPicView.h"
#import "ITTImageView.h"

@interface SZMerchantDetailPicView()
@property (nonatomic, strong) ITTImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation SZMerchantDetailPicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired  = 1;
        _imageView = [[ITTImageView alloc]initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.placeHolder =[UIImage imageNamed:@"SZ_NEARBY_PRODECT_DEFAULT.png"];
        [_imageView loadImage:self.pic.pic_url];
        [_imageView addGestureRecognizer:tap];
        [self addSubview:_imageView];
        
        UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-26, self.bounds.size.width, 26)];
        bgLabel.backgroundColor = [UIColor whiteColor];
        bgLabel.alpha = 0.9f;
        [self addSubview:bgLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-26, self.bounds.size.width, 26)];
        _contentLabel.font = [UIFont systemFontOfSize:12.f];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired  = 1;
        _imageView = [[ITTImageView alloc]initWithFrame:self.bounds];
        _imageView.placeHolder =[UIImage imageNamed:@"SZ_NEARBY_PRODECT_DEFAULT.png"];
        [_imageView loadImage:self.pic.pic_url];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageView addGestureRecognizer:tap];
        [self addSubview:_imageView];
        
        UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-26, self.bounds.size.width, 26)];
        bgLabel.backgroundColor = [UIColor whiteColor];
        bgLabel.alpha = 0.9f;
        [self addSubview:bgLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-26, self.bounds.size.width, 26)];
        _contentLabel.font = [UIFont systemFontOfSize:12.f];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)tap:(id)sender
{
    if (self.click!=nil) {
        self.click(self.pic);
    }
}

- (void)setPic:(SZNearByProductPicModel *)pic
{
    _pic = [pic copy];
     [_imageView loadImage:_pic.pic_url placeHolder:[UIImage imageNamed:@"SZ_NEARBY_PRODECT_DEFAULT.png"]];
    _contentLabel.text = _pic.title;
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
