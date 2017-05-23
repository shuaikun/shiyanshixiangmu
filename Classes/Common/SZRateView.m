//
//  SZRateView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZRateView.h"

@interface SZRateView()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *forthView;
@property (weak, nonatomic) IBOutlet UIView *fifthView;

@end

@implementation SZRateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStarLevel:(CGFloat)starLevel
{
    _firstView.width = 0.f;
    _secondView.width = 0.f;
    _thirdView.width = 0.f;
    _forthView.width = 0.f;
    _fifthView.width = 0.f;
    if(starLevel>=0){
        CGFloat level = starLevel-0;
        if(level>=1){
            _firstView.width = 14;
        }
        else{
            _firstView.width = 14*level;
        }
    }
    if(starLevel>=1){
        CGFloat level = starLevel-1;
        if(level>=1){
            _secondView.width = 14;
        }
        else{
            _secondView.width = 14*level;
        }
    }
    if(starLevel>=2){
        CGFloat level = starLevel-2;
        if(level>=1){
            _thirdView.width = 14;
        }
        else{
            _thirdView.width = 14*level;
        }
    }
    if(starLevel>=3){
        CGFloat level = starLevel-3;
        if(level>=1){
            _forthView.width = 14;
        }
        else{
            _forthView.width = 14*level;
        }
    }
    if(starLevel>=4){
        CGFloat level = starLevel-4;
        if(level>=1){
            _fifthView.width = 14;
        }
        else{
            _fifthView.width = 14*level;
        }
    }
}

@end














