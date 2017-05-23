//
//  TwoDimensionalCodeShadowView.m
//  SinaLiftCircle
//
//  Created by 王琦 on 13-11-1.
//
//

#import "TwoDimensionalCodeShadowView.h"

@implementation TwoDimensionalCodeShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGRect rect1 = CGRectMake(0, 0, 320, 112);
    CGRect rect2 = CGRectMake(0, 112, 42, 296);
    CGRect rect3 = CGRectMake(278, 112, 42, 296);
    CGRect rect4 = CGRectMake(0, 348, 320, self.bounds.size.height-348);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, [UIColor blackColor].CGColor);
    CGContextFillRect(ref, rect1);
    CGContextFillRect(ref, rect2);
    CGContextFillRect(ref, rect3);
    CGContextFillRect(ref, rect4);
}


@end
