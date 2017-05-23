//
//  SZNearByProductListCell.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByProductListCell.h"
#import "SZMerchantDetailPicView.h"
#import "SZNearByProductPicModel.h"
@interface SZNearByProductListCell()

@property (weak, nonatomic) IBOutlet SZMerchantDetailPicView *leftPicView;
@property (weak, nonatomic) IBOutlet SZMerchantDetailPicView *rightPicView;
@end
@implementation SZNearByProductListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configModel:(id)model
{
    if ([model isKindOfClass:[NSArray class]]&&[model count]!=0) {
        NSArray *pics = (NSArray *)model;
        [pics enumerateObjectsUsingBlock:^(SZNearByProductPicModel *obj, NSUInteger index, BOOL *stop){
            if (index%2==0) {
                self.leftPicView.pic = obj;
                self.leftPicView.click = ^(SZNearByProductPicModel *pic){
                    if (self.click!=nil) {
                        self.click(pic);
                    }
                };
            }else{
                self.rightPicView.pic = obj;
                self.rightPicView.click = ^(SZNearByProductPicModel *pic){
                    if (self.click!=nil) {
                        self.click(pic);
                    }
                };
            }
        }];
    }
    if (self.rightPicView.pic==nil) {
        self.rightPicView.hidden = YES;
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
