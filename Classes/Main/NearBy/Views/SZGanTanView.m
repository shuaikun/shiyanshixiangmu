//
//  SZGanTanView.m
//  jingTanHao
//
//  Created by 成焱 on 14-5-7.
//  Copyright (c) 2014年 成焱. All rights reserved.
//

#import "SZGanTanView.h"

@implementation SZGanTanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawWithContext:(CGContextRef)context
{
    CGRect bounds = CGRectMake(self.bounds.size.width/4, self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeEllipseInRect(context, bounds);
    CGContextMoveToPoint(context, self.bounds.size.width/2, self.bounds.size.height*3/4-self.bounds.size.height*4/40);
    CGContextAddLineToPoint(context, self.bounds.size.width/2, self.bounds.size.height*3/4-self.bounds.size.height*3/40);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, self.bounds.size.width/2, self.bounds.size.height*2/4+self.bounds.size.height/8);
    CGContextAddLineToPoint(context, self.bounds.size.width/2, self.bounds.size.height/4+self.bounds.size.height/10);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawWithContext:context];
}

@end
