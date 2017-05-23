//
//  SZMerchantDetailAroundView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailAroundView.h"
#import "SZMerchantDetailAroundCellView.h"
#import "SZNearByAroundStoreModel.h"
const float outGap = 15.f;
const float innerGap = 5.f;
const float lineHeight = 25.f;
@interface SZMerchantDetailAroundView()
{
    float sizeWidth;
    float x;
    float y;
}
@end
@implementation SZMerchantDetailAroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame aroundShops:(NSMutableArray *)shops
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        NSInteger count = [shops count];
        float height = 0;
        if (count==0) {
            height = 0;
            self.height = height;
        }else{
            
            self.backgroundColor = [UIColor whiteColor];
            UIView *bgColorview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 33)];
            bgColorview.backgroundColor = RGBCOLOR(248, 248, 248);
            [self addSubview:bgColorview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 305, 33)];
            label.backgroundColor = RGBCOLOR(248, 248, 248);
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = @"周边商户推荐";
            
            [self addSubview:label];
            
            sizeWidth = 0;
            x = outGap;
            y = outGap+33;
            [shops enumerateObjectsUsingBlock:^(SZNearByAroundStoreModel* obj, NSUInteger index, BOOL *stop){
                if ( [obj isKindOfClass:[SZNearByAroundStoreModel class]]) {
                    
                    sizeWidth = [obj.store_name sizeWithFont:[UIFont systemFontOfSize:13.f]].width+ 2 *innerGap;
                    
                    if (x+sizeWidth+outGap>=320) {
                        x = outGap;
                        y += lineHeight + outGap;
                    }
                    
                    SZMerchantDetailAroundCellView *cell = [[SZMerchantDetailAroundCellView alloc]initWithFrame:CGRectMake(x, y, sizeWidth, lineHeight)];
                    cell.text = obj.store_name;
                    cell.click = ^(void){
                         self.click(obj.store_id);
                    };
                    [self addSubview:cell];
                    
                    x += sizeWidth + outGap;
                    
                }
            }];
            
            self.height = y + lineHeight + outGap;
        }

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

@end
