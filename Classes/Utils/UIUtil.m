//
//  UIUtil.m
//  
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"
#import "CONSTS.h"
#import "UIDevice+ITTAdditions.h"

@implementation UIUtil

+ (void)adjustPositionToPixel:(UIView*)view
{
	view.center = CGPointMake(round(view.center.x), round(view.center.y));
}

+ (void)adjustPositionToPixelByOrigin:(UIView*)view
{
	view.left = round(view.left);
	view.top = round(view.top);
}

+ (NSString*)imageName:(NSString*) name
{
	if (![[UIDevice currentDevice] hasRetinaDisplay]) {
		name = [name stringByAppendingString:@".png"];
	}
	return name;
}

+ (void)setRoundCornerForView:(UIView*)view withRadius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    [view setNeedsDisplay];
}

+ (void)setBorderForView:(UIView*)view withWidth:(CGFloat)width withColor:(UIColor*)color
{
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    [view setNeedsDisplay];
}

+ (CGFloat)getLabelHeightWithFontSize:(CGFloat)size Width:(CGFloat)width String:(NSString *)string
{
    CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    return stringSize.height;
}

+ (CGFloat)getLabelWidthWithFontSize:(CGFloat)size String:(NSString *)string
{
    CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(10000, 21) lineBreakMode:NSLineBreakByTruncatingTail];
    return stringSize.width;
}

+(void) addAnimationShakeInView:(UIView *) tempView minShowScal:(float) minShowScal  maxShowScal:(float) maxShowScal  middleShowScal:(float) middleShowScal delegate:(id) delegate
{
    CAKeyframeAnimation *animation=nil;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = delegate;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(minShowScal, minShowScal, minShowScal)]];//0.1
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(maxShowScal, maxShowScal, maxShowScal)]]; //1.2
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(middleShowScal, middleShowScal, middleShowScal)]]; //0.9
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [tempView.layer addAnimation:animation forKey:nil];
}

+(void) addAnimationScal:(UIView *)tempView  toPoint:(CGPoint)center  lightState:(int) getLightState  delegate:(id) delegate startSelector:(SEL) startSelector stopSelector:(SEL) stopSelector scaleNumber:(float) number duraion:(CFTimeInterval) seconds
{
	if (getLightState<2)
    tempView.alpha = getLightState? 0 : 1;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:delegate];
	[UIView setAnimationWillStartSelector:startSelector];
	[UIView setAnimationDidStopSelector:stopSelector];
	[UIView setAnimationDuration:seconds];
	tempView.transform = CGAffineTransformMakeScale(number, number);
	tempView.center = center;
    if (getLightState<2)
    tempView.alpha = getLightState ? 1 : 0;
	[UIView commitAnimations];
}

+ (NSString *)getBaseTimeString:(NSTimeInterval)time
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}

+ (NSString *)getLongTimeString:(NSTimeInterval)time
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yyyyStr1 = [dateFormatter stringFromDate:[NSDate date]];
    NSString *yyyyStr2 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    [dateFormatter setDateFormat:@"MM"];
    NSString *mmStr1 = [dateFormatter stringFromDate:[NSDate date]];
    NSString *mmStr2 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    [dateFormatter setDateFormat:@"dd"];
    NSString *ddStr1 = [dateFormatter stringFromDate:[NSDate date]];
    NSString *ddStr2 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    if([yyyyStr1 isEqualToString:yyyyStr2] && [mmStr1 isEqualToString:mmStr2] && [ddStr1 isEqualToString:ddStr2]){
        //today
        [dateFormatter setDateFormat:@"hh"];
        NSString *hhStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        [dateFormatter setDateFormat:@"mm"];
        NSString *mmStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        string = [NSString stringWithFormat:@"今天 %@:%@",hhStr,mmStr];
    }
    else{
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    }
    return string;
}

+ (NSString *)getTimeString:(NSDate*)time
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    string = [dateFormatter stringFromDate:time];
    
    return string;
}

+ (NSString *)getDateString:(NSDate*)date
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    string = [dateFormatter stringFromDate:date];
    return string;
}

+(NSString*) DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
