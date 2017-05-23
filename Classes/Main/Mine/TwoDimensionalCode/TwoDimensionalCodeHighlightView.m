//
//  TwoDimensionalCodeHighlightView.m
//  SinaLiftCircle
//
//  Created by 王琦 on 13-11-1.
//
//

#import "TwoDimensionalCodeHighlightView.h"

@implementation TwoDimensionalCodeHighlightView

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
    CGRect shiZiBounds = self.bounds;
    float gab = 0;
    float bianJiaoLength = 14;
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ref, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ref, 8);
    
    CGContextMoveToPoint(ref, gab, gab + bianJiaoLength);
    CGContextAddLineToPoint(ref, gab, gab);
    CGContextAddLineToPoint(ref, gab + bianJiaoLength, gab);
    
    CGContextMoveToPoint(ref, shiZiBounds.size.width - gab - bianJiaoLength, gab);
    CGContextAddLineToPoint(ref, shiZiBounds.size.width - gab, gab);
    CGContextAddLineToPoint(ref, shiZiBounds.size.width - gab, gab + bianJiaoLength);
    
    CGContextMoveToPoint(ref,gab, shiZiBounds.size.height - gab - bianJiaoLength);
    CGContextAddLineToPoint(ref, gab, shiZiBounds.size.height - gab);
    CGContextAddLineToPoint(ref, gab + bianJiaoLength, shiZiBounds.size.height - gab);
    
    CGContextMoveToPoint(ref, shiZiBounds.size.width - gab - bianJiaoLength, shiZiBounds.size.height - gab);
    CGContextAddLineToPoint(ref, shiZiBounds.size.width - gab, shiZiBounds.size.height - gab);
    CGContextAddLineToPoint(ref, shiZiBounds.size.width - gab , shiZiBounds.size.height - gab - bianJiaoLength);
    
    CGContextStrokePath(ref);
    
}


@end
