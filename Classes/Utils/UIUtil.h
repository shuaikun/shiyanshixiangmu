//
//  UIUtil.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CONSTS.h"

@interface UIUtil : NSObject

+ (void)adjustPositionToPixel:(UIView*)view;
+ (void)adjustPositionToPixelByOrigin:(UIView*)view;
+ (void)setRoundCornerForView:(UIView*)view withRadius:(CGFloat)radius;
+ (void)setBorderForView:(UIView*)view withWidth:(CGFloat)width withColor:(UIColor*)color;

+ (NSString *)imageName:(NSString *)name;

+ (CGFloat)getLabelWidthWithFontSize:(CGFloat)size String:(NSString *)string;

+ (CGFloat)getLabelHeightWithFontSize:(CGFloat)size Width:(CGFloat)width String:(NSString *)string;

+(void)addAnimationShakeInView:(UIView *) tempView minShowScal:(float) minShowScal  maxShowScal:(float) maxShowScal  middleShowScal:(float) middleShowScal delegate:(id) delegate;

+(void)addAnimationScal:(UIView *)tempView  toPoint:(CGPoint)center  lightState:(int) getLightState  delegate:(id) delegate startSelector:(SEL) startSelector stopSelector:(SEL) stopSelector scaleNumber:(float) number duraion:(CFTimeInterval) seconds;

+ (NSString *)getBaseTimeString:(NSTimeInterval)time;

+ (NSString *)getLongTimeString:(NSTimeInterval)time;
+ (NSString *)getTimeString:(NSDate*)time;

+ (NSString *)getDateString:(NSDate*)date;


+ (NSString *)DataTOjsonString:(id)object;
@end
