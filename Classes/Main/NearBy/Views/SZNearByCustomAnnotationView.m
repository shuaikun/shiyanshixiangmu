//
//  SZHNearByCustomAnnotationView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-22.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByCustomAnnotationView.h"
#import "SZNearByCustomAnnotation.h"
#import "SZMapAnnotationCallOutView.h"
#define Arror_height 6.0f
@interface SZNearByCustomAnnotationView()
@property (nonatomic, strong) SZMapAnnotationCallOutView *mapCallOut;
@end

@implementation SZNearByCustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -85);
        self.frame = CGRectMake(0, 0, 180, 95);
        self.mapCallOut = [SZMapAnnotationCallOutView loadFromXib];
        self.mapCallOut.frame = CGRectMake(1, 1, 178, 88);
        [self addSubview:self.mapCallOut];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInContext:context];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(222, 222, 222).CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];

}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;

    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    CGContextAddLineToPoint(context, minx, maxy);
    CGContextAddLineToPoint(context, minx, miny);
    CGContextAddLineToPoint(context, maxx, miny);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextAddLineToPoint(context, midx+Arror_height, maxy);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    CGContextAddLineToPoint(context, minx, maxy);
    CGContextAddLineToPoint(context, minx, miny);
    CGContextAddLineToPoint(context, maxx, miny);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextAddLineToPoint(context, midx+Arror_height, maxy);
    CGContextStrokePath(context);
}

- (void)configWithModel:(id)model
{
    if ([model isKindOfClass:[SZNearByCustomAnnotation class]]) {
        SZNearByCustomAnnotation *custom = (SZNearByCustomAnnotation *)model;
        __block SZNearByCustomAnnotationView *weakSelf = self;
        self.mapCallOut.nameLabel.text = custom.storeName;
        self.mapCallOut.starView.starLevel = [custom.score intValue];
        self.mapCallOut.price.text = [NSString stringWithFormat:@"￥%d",[custom.capita integerValue]];
        self.mapCallOut.address.text = custom.address;
        self.mapCallOut.storeId = custom.storeId;
        self.mapCallOut.iconsFlag = custom.iconFlag;
        self.mapCallOut.click = ^(NSString *storeId){
            if (weakSelf.click!=nil) {
                weakSelf.click(storeId);
            }
        };

    }
}
@end
