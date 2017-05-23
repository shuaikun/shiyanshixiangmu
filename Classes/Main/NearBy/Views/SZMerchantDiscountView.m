//
//  SZMerchantDiscountView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDiscountView.h"
#import "SZMerchantDiscounuCellView.h"
#import "SZNearByMerchantDetailModel.h"
#import "SZNearByGoodModel.h"
const float labelFont = 13.f;
float height = 0.0f;

@interface SZMerchantDiscountView()
{
    NSMutableArray *cells;
}
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, assign) NSInteger count;
- (void)handleMoreBtnClick:(id)sender;
@end

@implementation SZMerchantDiscountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame discounts:(NSMutableArray *)goods
{
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    cells = [[NSMutableArray alloc]init];
    self.clipsToBounds = YES;
    height = frame.size.height;
    if (self) {
        _count = [goods count];
        if (_count == 0) {
            height = 0;
        }else {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 55, 33)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:labelFont];
            label.text = @"优惠券";
            [self addSubview:label];
            for (int i = 0;i<_count; i++) {
                SZNearByGoodModel *good = [goods objectAtIndex:i];
                SZMerchantDiscounuCellView *cell = [[SZMerchantDiscounuCellView alloc]initWithFrame:CGRectMake(0, i*44+33, 320, 44)];
                
                /**这里需要将model传进来设置cell***/
    
                cell.contentLabel.text = good.goods_name;
                cell.imageView.image = [good.type intValue]==1?ImageNamed(@"SZ_Mine_Quan_Icon.png"):ImageNamed(@"SZ_Mine_Card_Icon.png");
                cell.click = ^(void){
                    if (self.clickCallBack!=nil) {
                        self.clickCallBack(good);
                    }
                };
                [cells addObject:cell];
                [self addSubview:cell];
            }
            if (_count>3) {
                [[(SZMerchantDiscounuCellView *)[cells objectAtIndex:2] bottomLine] setHidden:YES];
                [[(SZMerchantDiscounuCellView *)[cells lastObject] bottomLine] setHidden:YES];
                _moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 3*44+33, 320, 40)];
                UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
                topLine.backgroundColor = RGBCOLOR(222, 222, 222);
                UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
                bottomLine.backgroundColor = RGBCOLOR(222, 222, 222);
                UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                moreBtn.frame = CGRectMake(0, 1, 320, 38);
                [moreBtn setTitleColor:RGBCOLOR(42, 172, 226) forState:UIControlStateNormal];
                [moreBtn setImage:ImageNamed(@"SZ_NEARBY_DOWN_ARROW.png") forState:UIControlStateNormal];
                [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 104, 0, 205)];
                [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
                [moreBtn setTitle:@"展开全部" forState:UIControlStateNormal];
                moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [moreBtn setBackgroundColor:[UIColor whiteColor]];
                [moreBtn addTarget:self action:@selector(handleMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_moreView addSubview:topLine];
                [_moreView addSubview:bottomLine];
                [_moreView addSubview:moreBtn];
                [self addSubview:_moreView];
                height = 44 * 3 + 40 + 33;
            }else{
                height = 44 * _count + 33;
            }
        }
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    }
    return self;
}

- (void)handleMoreBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (![[[btn titleLabel]text]isEqualToString:@"展开全部"]) {
        [btn setImage:ImageNamed(@"SZ_NEARBY_DOWN_ARROW.png") forState:UIControlStateNormal];
        [btn setTitle:@"展开全部" forState:UIControlStateNormal];
        [[(SZMerchantDiscounuCellView *)[cells objectAtIndex:2] bottomLine] setHidden:YES];
        [UIView animateWithDuration:0.3f animations:^(void){
            self.height = height;
            _moreView.top = self.height - 40;
        }];
        if (self.callBack!=nil) {
            self.callBack(44 * _count  +33 +40 - (44 * 3 + 33 + 40),NO);
        }
    }else{
        [btn setImage:ImageNamed(@"SZ_NEARBY_UP_ARROW.png") forState:UIControlStateNormal];
        [btn setTitle:@"隐藏" forState:UIControlStateNormal];
        [[(SZMerchantDiscounuCellView *)[cells objectAtIndex:2] bottomLine] setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^(void){
            self.height = 44 * _count  +33 +40;
            _moreView.top = self.height - 40;
        }];
        if (self.callBack!=nil) {
            self.callBack(44 * _count  +33 +40 - (44 * 3 + 33 + 40),YES);
        }
    }

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
