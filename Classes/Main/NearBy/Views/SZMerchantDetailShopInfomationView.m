//
//  SZMerchantDetailShopInfomationView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailShopInfomationView.h"

@interface SZMerchantDetailShopInfomationView()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *constTimeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *addtionLabel;
@property (nonatomic, strong) UIView *addtionView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *mapClickView;
@end

@implementation SZMerchantDetailShopInfomationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgColorview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 33)];
        bgColorview.backgroundColor = RGBCOLOR(248, 248, 248);
        [self addSubview:bgColorview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 305, 33)];
        label.backgroundColor = RGBCOLOR(248, 248, 248);
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = @"商户信息";
        [self addSubview:label];
        
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(233, 45, 1, 65)];
        rightLine.backgroundColor = RGBACOLOR(222, 222, 222, 1);
        [self addSubview:rightLine];
        
        UIImageView *imgA = [[UIImageView alloc]initWithFrame:CGRectMake(14, 18+33, 13, 11)];
        imgA.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Address.png"];
        [self addSubview:imgA];
        
        UIImageView *imgB = [[UIImageView alloc]initWithFrame:CGRectMake(246, 34+33, 15, 22)];
        imgB.image = [UIImage imageNamed:@"SZ_NearBy_Location_Normal.png"];
        [self addSubview:imgB];
        

        
        UIFont *font = [UIFont systemFontOfSize:13.f];
        UIColor *color = [UIColor blackColor];
        UIColor *bgColor = [UIColor clearColor];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 46,199, 36)];
        _addressLabel.clipsToBounds = YES;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = color;
        _addressLabel.font = [UIFont systemFontOfSize:13.f];
        _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _addressLabel.numberOfLines = 0;
        _addressLabel.backgroundColor = bgColor;
        _addressLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_addressLabel];
        
        _constTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(29, 57+33, 59, 21)];
        _constTimeLabel.font = font;
        _constTimeLabel.textColor = [UIColor blackColor];
        _constTimeLabel.text = @"营业时间:";
        [self addSubview:_constTimeLabel];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 57+33,199, 21)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = RGBCOLOR(42, 172, 226);
        _timeLabel.font = font;
        _timeLabel.backgroundColor = bgColor;
        [self addSubview:_timeLabel];
        
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(265, 34+33,56, 21)];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.textColor = RGBCOLOR(42, 172, 226);
        _distanceLabel.font = font;
        _distanceLabel.backgroundColor = bgColor;
        [self addSubview:_distanceLabel];
        
        UIImageView *imgC = [[UIImageView alloc]initWithFrame:CGRectMake(17, 16, 13, 11)];
        imgC.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Car_Park.png"];
        
        _addtionLabel = [[UILabel alloc]initWithFrame:CGRectMake(33, 11,284, 21)];
        _addtionLabel.textAlignment = NSTextAlignmentLeft;
        _addtionLabel.textColor = color;
        _addtionLabel.font = font;
        _addtionLabel.numberOfLines = 0;
        _addtionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _addtionLabel.backgroundColor = bgColor;
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        topLine.backgroundColor = RGBCOLOR(222, 222, 222);
        
        _bottomLine =  [[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, 1)];
        _bottomLine.backgroundColor = RGBCOLOR(222, 222, 222);
        
        _addtionView = [[UIView alloc]initWithFrame:CGRectMake(0, 133, 320, 44)];
        _addtionView.backgroundColor = [UIColor whiteColor];
        
        [_addtionView addSubview:imgC];
        [_addtionView addSubview:_addtionLabel];
        [_addtionView addSubview:topLine];
        [_addtionView addSubview:_bottomLine];
        
        
        _mapClickView = [[UIView alloc]initWithFrame:CGRectMake(234, 33, 86, 100)];
        _mapClickView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapMapClick:)];
        tap.numberOfTapsRequired = 1;
        [_mapClickView addGestureRecognizer:tap];
        [self addSubview:_mapClickView];
        
        [self addSubview:_addtionView];
        
        

    }
    return self;
}

- (void)setAddress:(NSString *)address
{
    if (IS_STRING_EMPTY(address)) {
        address = @"";
    }
    _address = [address copy];
    float height = ceilf([address heightWithFont:[UIFont systemFontOfSize:13.f] withLineWidth:199.0f]);
    if (height<21.f) {
        height = 21.f;
    }
    float defaultHeight = 36.f;
    float offSet = defaultHeight - height;
    _addressLabel.text = address;
    _addressLabel.height= height;
    _addtionView.top-=offSet;
    _constTimeLabel.top-=offSet;
    _timeLabel.top-=offSet;
    self.height -=offSet;
}

- (void)setAddtion:(NSString *)addtion
{
    if (IS_STRING_EMPTY(addtion)) {
        addtion = @"";
    }
    _addtion = addtion;
    float height = ceilf([addtion heightWithFont:[UIFont systemFontOfSize:13.f] withLineWidth:284.f]) ;
    if (height<21.f) {
        height = 21.f;
    }
    float defaultHeight = 21.f;
    float offSet = defaultHeight - height;
    [_addtionLabel setHeight:height];
    _addtionLabel.text = addtion;
    _addtionView.height -=offSet;
    _bottomLine.top-=offSet;
    self.height-=offSet;
    
}

- (void)setTime:(NSString *)time
{
    if (IS_STRING_EMPTY(time)) {
        time = @"";
    }
    _time = [time copy];
    self.timeLabel.text = _time ;
}

- (void)setDistance:(NSString *)distance
{
    if (IS_STRING_EMPTY(distance)) {
        distance = @"";
    }
    _distance = [distance copy];
    self.distanceLabel.text = _distance;
}

- (void)handleTapMapClick:(id)sender
{
    NSLog(@"----");
    if (self.mapClick) {
        [self mapClick]();
    }
}
@end
