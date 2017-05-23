//
//  SZStarView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZStarView.h"

@interface SZStarView()
{
    NSArray *stars;
}
@property (strong, nonatomic) IBOutlet UIImageView *starA;
@property (strong, nonatomic) IBOutlet UIImageView *starB;
@property (strong, nonatomic) IBOutlet UIImageView *starC;
@property (strong, nonatomic) IBOutlet UIImageView *starD;
@property (strong, nonatomic) IBOutlet UIImageView *starE;

@end

@implementation SZStarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _starA = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _starB = [[UIImageView alloc]initWithFrame:CGRectMake(17, 0, 14, 14)];
        _starC = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 14, 14)];
        _starD = [[UIImageView alloc]initWithFrame:CGRectMake(52, 0, 14, 14)];
        _starE = [[UIImageView alloc]initWithFrame:CGRectMake(69, 0, 14, 14)];
         stars = [NSArray arrayWithObjects:_starA,_starB,_starC,_starD,_starE, nil];
        for (UIImageView *star in stars) {
            [star setImage:[UIImage imageNamed:@"SZ_Mine_Star_Gray.png"]];
            [star setHighlightedImage:[UIImage imageNamed:@"SZ_Mine_Star_Red.png"]];
        }
        [self addSubview:_starA];
        [self addSubview:_starB];
        [self addSubview:_starC];
        [self addSubview:_starD];
        [self addSubview:_starE];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _starA = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _starB = [[UIImageView alloc]initWithFrame:CGRectMake(17, 0, 14, 14)];
        _starC = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 14, 14)];
        _starD = [[UIImageView alloc]initWithFrame:CGRectMake(52, 0, 14, 14)];
        _starE = [[UIImageView alloc]initWithFrame:CGRectMake(69, 0, 14, 14)];
        stars = [NSArray arrayWithObjects:_starA,_starB,_starC,_starD,_starE, nil];
        for (UIImageView *star in stars) {
            [star setImage:[UIImage imageNamed:@"SZ_Mine_Star_Gray.png"]];
            [star setHighlightedImage:[UIImage imageNamed:@"SZ_Mine_Star_Red.png"]];
        }
        [self addSubview:_starA];
        [self addSubview:_starB];
        [self addSubview:_starC];
        [self addSubview:_starD];
        [self addSubview:_starE];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    stars = [NSArray arrayWithObjects:self.starA,self.starB,self.starC,self.starD,self.starE, nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setStarLevel:(NSInteger)starLevel
{
    _starLevel = starLevel;
    [stars enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger index, BOOL *stop){
        if (index<starLevel) {
            [obj setHighlighted:YES];
        }else{
            [obj setHighlighted:NO];
        }
    }];
}
@end
