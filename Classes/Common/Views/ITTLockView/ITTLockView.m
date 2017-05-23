//
//  LockView.m
//  LockDemo
//
//  Created by 胡鹏 on 7/30/13.
//  Copyright (c) 2013 isoftStone. All rights reserved.
//

#import "ITTLockView.h"

@interface ITTLockView()
{
    float _circleThickness;
    float _circleRadius;
//    UIColor *_circleColor;
//    UIColor *_circleFillColor;
    
    __strong UIColor *_circleColor;
    __strong UIColor *_circleFillColor;
    /**
     *	_maskImageView used to show moving lines
     * self only show the static image
     */ 
    
    UIImageView *_maskImageView;
    
    NSMutableArray *_responseAreas;
    
    BOOL _currentState;

    CGPoint _lastSelectedPoint;
}


#pragma mark - methods to drawing the interface

- (void)setUp;

- (void)initLockView;

- (void)drawCircle:(CGPoint)center radius:(float)radius lineWidth:(int)lineWidth lineColor:(UIColor*)color fillColor:(UIColor *)fillColor;

#pragma mark - methods to handle event of selecting a point


/**
 *	check touch point is in one of the response areas or not
 *
 *	@param	point	touch point
 *	@param	rects	response areas
 *
 *	@return	the index of the selected area, -1 if no area was selected
 */
//- (NSInteger)checkPoint:(CGPoint)point inRects:(NSMutableArray *)rects;

- (NSInteger)checkPointWhetherInResponseRectsOrNot:(CGPoint)point;

- (BOOL)checkPoint:(CGPoint)point inRect:(CGRect)rect;

/**
 *  not really selected the circle in this method
 *
 *	@param	index 
 *
 *	@return	if point could be selected ,return true ,else false
 */
- (BOOL)selectCircleAtIndex:(NSInteger)index;

- (void)didSelectCircleAtIndex:(NSInteger)index;

- (void)connect:(CGPoint)startPoint toPoint:(CGPoint)endPoint inContext:(CGContextRef)context;

#pragma mark - methods to handle event of touch move

- (void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

/* 
 *  return -1 if blocked,
 *  return 0 if two point are adjacent,
 *  return unselected index between two point
 */
- (NSInteger)checkConnectedBetweenIndex:(NSInteger)startIndex andIndex:(NSInteger)endIndex;

@end

@implementation ITTLockView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_touchesEnabled) {
        return;
    }    
    
    UITouch *touch = [touches anyObject];
    _lastSelectedPoint = [touch locationInView:self];

    /**
     *	if touch point in one of the response areas, selected the Circle
     *  else not response
     */ 
    
//    NSInteger index = [self checkPoint:_lastSelectedPoint inRects:_responseAreas];
    NSInteger index = [self checkPointWhetherInResponseRectsOrNot:_lastSelectedPoint];
    
//    if (index <0) {
    if (index == NSNotFound) {
        
        _lastSelectedPoint = CGPointZero;
        return;
        
    }
    [self selectCircleAtIndex:index];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_touchesEnabled) {
        return;
    }
    
    // 1. if start point is not in response areas,return
    if (CGPointEqualToPoint(_lastSelectedPoint,CGPointZero)) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    // 2. drawing line from the last selected point while moving
    
    [self drawLineFromPoint:_lastSelectedPoint toPoint:currentPoint];
    
    // 3. check touch point is in one of the circle or not
//    NSInteger index = [self checkPoint:currentPoint inRects:_responseAreas];
    NSInteger index = [self checkPointWhetherInResponseRectsOrNot:currentPoint];
    
//    if (index >=0) {
    if (index != NSNotFound) {
        [self selectCircleAtIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_touchesEnabled) {
        return;
    }
    self.currentState = normalState;
    
    if ([_selectedIndexs count]>0) {
        self.touchesEnabled = false;
    }
    
    

    if ([_delegate respondsToSelector:@selector(touchesEnd:)]) {
        [_delegate touchesEnd:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - init methods

- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color circleThickness:(float)thickness circleFillColor:(UIColor *)fillColor
{
    _circleFillColor = fillColor;
    return [self initWithFrame:frame circleRadius:radius circleColor:color circleThickness:thickness];
}

- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color circleThickness:(float)thickness
{
    _circleThickness = thickness;
    return [self initWithFrame:frame circleRadius:radius circleColor:color];
}


- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color
{
    _circleRadius = radius;
//    _circleColor = [color retain];
    _circleColor = color;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUp];
        
        [self initLockView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
    
    [self initLockView];
}

// comment here for arc environment

//- (void)dealloc
//{
//    [_circleColor release];
//    [_circleFillColor release];
//    [_responseAreas release];
//    [_maskImageView release];
//    [_lineColor release];
//    [_lineColor4FalseState release];
//    [super dealloc];
//}

#pragma mark - methods to drawing interface
/**
 *	check parameters is valid or not ,
 *  if invalid, use default value
 */
- (void)setUp
{    
    self.userInteractionEnabled = true;
    self.touchesEnabled = true;
    
    if (_circleThickness<1) {
        _circleThickness = 3;
    }
    if (_circleRadius<1) {
        _circleRadius = 30;
    }
    if (!_circleColor) {
        _circleColor = [UIColor grayColor];
    }
    if (!_circleFillColor) {
        _circleFillColor = [UIColor blackColor];
    }
    _currentState = normalState;
}

/**
 *	rest lock view - clear interface and reset parameters
 */
- (void)initLockView
{
    // 1.clear subviews
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    // 2.clear imageView and maskImageView 
    self.image = nil;
    
    if (_maskImageView == nil) {
        
        _maskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _maskImageView.backgroundColor = [UIColor clearColor];
        
    }
    _maskImageView.image = nil;
    
    [self addSubview:_maskImageView];
    
    // 3.init parameters
    
    if (!_responseAreas) {
        _responseAreas = [[NSMutableArray alloc] initWithCapacity:9];
    }
    
    if (!_selectedIndexs) {
        _selectedIndexs = [[NSMutableArray alloc] initWithCapacity:9];
    }
    [_responseAreas removeAllObjects];
    [_selectedIndexs removeAllObjects];
    
    _lastSelectedPoint = CGPointZero;

    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    float offsetY = 0;
    float xDistance = (w-6*_circleRadius)/4.0;
    float yDistance = (h-offsetY-6*_circleRadius)/4.0;
    
    int lockNumber = 9;
    
    // 4. draw nine point
    
    for (int i = 0 ; i< lockNumber; i++) {
        
        int line = i/3+1;
        int column = i%3+1;
        
        CGPoint center = CGPointMake(xDistance*column+ (2*column-1)*_circleRadius, offsetY+yDistance*line+(2*line-1)*_circleRadius);
        
        // 4.1 draw one circle
        [self drawCircle:center radius:_circleRadius lineWidth:_circleThickness lineColor:_circleColor fillColor:_circleFillColor];
        
        
        // 4.2 record circle's response area,
        
        CGRect rect = CGRectMake(center.x-_circleRadius, center.y-_circleRadius, 2*_circleRadius, 2*_circleRadius);
        
        // u can set it bigger if needed
        CGRect responseRect = CGRectInset(rect, 0, 0);
        
        [_responseAreas addObject:NSStringFromCGRect(responseRect)];
    }
}


- (void)drawCircle:(CGPoint)center radius:(float)radius lineWidth:(int)lineWidth lineColor:(UIColor*)color fillColor:(UIColor *)fillColor
{
    // 1.push a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, FALSE, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSetShouldAntialias(context, TRUE);
    
    // 2.render original image in the context
    [self.image drawInRect:self.bounds];
    
    // 3. draw a new circle
    CGContextAddArc(context, center.x, center.y, radius, 0, 2*3.14, 0);
    CGContextSetLineWidth(context, lineWidth);
    UIColor *lineColor = color;
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextStrokePath(context);
    
    // 4. fill the circle
    CGContextAddArc(context, center.x, center.y, radius-lineWidth/2, 0, 2*3.14, 0);
    
    CGContextSetFillColorWithColor(context, _circleFillColor.CGColor);
    CGContextFillPath(context);
    
    // 5.save image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.save context 
    CGContextSaveGState(context);
    UIGraphicsEndImageContext();
}

#pragma mark - methods to handle event of selecting a point

//- (NSInteger)checkPoint:(CGPoint)point inRects:(NSMutableArray *)rects
//{
//    for (int i = 0; i<[rects count]; i++) {
//        NSString *sRect = [rects objectAtIndex:i];
//        
//        if ([self checkPoint:point inRect:CGRectFromString(sRect)]) {
//            return i;
//        }
//    }
//    
//    return -1;
//}

- (NSInteger)checkPointWhetherInResponseRectsOrNot:(CGPoint)point
{
    for (int i = 0; i<[_responseAreas count]; i++) {
        NSString *sRect = [_responseAreas objectAtIndex:i];
        
        if ([self checkPoint:point inRect:CGRectFromString(sRect)]) {
            return i;
        }
    }
    
    return NSNotFound;
}


- (BOOL)checkPoint:(CGPoint)point inRect:(CGRect)rect
{
    Boolean xValid = (point.x>=rect.origin.x) && (point.x<= rect.origin.x+rect.size.width);
    Boolean yValid = (point.y>=rect.origin.y) && (point.y<= rect.origin.y+rect.size.height);
    return xValid && yValid;
}

- (BOOL)selectCircleAtIndex:(NSInteger)index
{
    // 1.if current point has been selected ,return
    if ([_selectedIndexs containsObject:[NSNumber numberWithInt:index]]) {
        return false;
    }
    
    /**
     *	if skip connection is not accepted
     */
    if (!_canSkipConnect) {

        // 2.if current point could connect to the last selected point,return
        
        NSInteger midPoint = 0;
        if ([_selectedIndexs count]>0) {
            midPoint = [self checkConnectedBetweenIndex:[[_selectedIndexs lastObject] intValue] andIndex:index];
            if (midPoint<0) {
                return false;
            }
        }
        
        // 3.select middle point first
        
        if (midPoint>0) {
            [self didSelectCircleAtIndex:midPoint];
        }
    }
    
    

    [self didSelectCircleAtIndex:index];
    
    return true;
}

- (NSInteger)checkConnectedBetweenIndex:(NSInteger)startIndex andIndex:(NSInteger)endIndex
{
    int midIndex = (startIndex+endIndex)/2;
    
    //始末点均为奇数点,只要中点不为4,均ok
    if (startIndex%2 == 1 && endIndex%2 == 1) {
        
        if (midIndex != 4) {
            return 0;
        }
    }
    //始末点一奇一偶，均ok
    if ((startIndex + endIndex)%2 == 1) {
        return 0;
    }
    //始末点均为偶数点,算中点是否选中
//    if (startIndex%2 == 0 && endIndex%2 == 0) {
//        
//    }
    // 算斜率
    CGPoint startPoint = CGPointMake(startIndex/3+1, startIndex%3+1);
    CGPoint endPoint = CGPointMake(endIndex/3+1, endIndex%3+1);
    CGPoint midPoint = CGPointMake(midIndex/3+1, midIndex%3+1);
    
    //3点不在一条直线上
    
    if ((midPoint.y - startPoint.y) != (endPoint.y - midPoint.y) || (midPoint.x - startPoint.x) != (endPoint.x - midPoint.x)) {
        return 0;
    }
    

    
    
    if ([_selectedIndexs containsObject:[NSNumber numberWithInt:midIndex]]) {
        return -1;
    }
    return midIndex;
//    if (startIndex == 0 && endIndex == 0) {
//        return 0;
//    }
//    if (startIndex == 4 || endIndex == 4) {
//        return 0;
//    }
//    float midPoint = (float)(startIndex+endIndex)/2.0;
//    
//    int iMidPoint = (int)midPoint;
//    
//    if (iMidPoint==midPoint) {
//        if ([_selectedIndexs containsObject:[NSNumber numberWithInt:iMidPoint]]) {
//            return -1;
//        } else {
//            
//            if (midPoint == 4) {
//                return midPoint;
//            } else if (startIndex%2==0 && endIndex%2==0) {
//                return midPoint;
//            } else {
//                return 0;
//            }
//        }
//    }
//    return 0;
}


- (void)didSelectCircleAtIndex:(NSInteger)index
{
    // 1. init the selected image
    
    if (!_selectedImage) {
        _selectedImage = [UIImage imageNamed:@"yellow_circle.png"];
    }
    if (!_selectedImage4FalseState) {
        _selectedImage4FalseState = [UIImage imageNamed:@"red_circle.png"];
    }
    UIImage *selectedImage = _currentState?_selectedImage:_selectedImage4FalseState;
    
    
    // 2. add the seleted imageView
    UIImageView *selectImageView = [[UIImageView alloc] initWithImage:selectedImage];
    NSString *sRect = [_responseAreas objectAtIndex:index];
    CGRect rect = CGRectFromString(sRect);
    selectImageView.frame = CGRectInset(rect, _circleRadius/4.0, _circleRadius/4.0);
    [self addSubview:selectImageView];
//    [selectImageView release];
    
    
    // 3. set start point the center of selected circle, for drawing next line start from current selected circle
    
    _lastSelectedPoint = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
    
    // 4. add a line between the last two selected circle if having
    
    if ([_selectedIndexs count]>0) {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, FALSE, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        
        NSString *sRect2 = [_responseAreas objectAtIndex:[[_selectedIndexs lastObject] intValue]];
        CGRect rect2 = CGRectFromString(sRect2);
        
        CGPoint startPoint =  CGPointMake(rect2.origin.x+rect2.size.width/2, rect2.origin.y+rect2.size.height/2);
        CGPoint endPoint = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
        
        [self.image drawInRect:self.bounds];
        
        [self connect:startPoint toPoint:endPoint inContext:context];
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGContextSaveGState(context);
        UIGraphicsEndImageContext();
    }
    
    // 5. record selected index
    
    [_selectedIndexs addObject:[NSNumber numberWithInt:index]];
    
}

- (void)connect:(CGPoint)startPoint toPoint:(CGPoint)endPoint inContext:(CGContextRef)context
{
    if (_lineWidth<1) {
        _lineWidth = 5;
    }
    if (!_lineColor) {
//        _lineColor = [[UIColor colorWithRed:252.0/255.0 green:212.0/255.0 blue:51.0/255.0 alpha:0.9] retain];
        self.lineColor = [UIColor colorWithRed:252.0/255.0 green:212.0/255.0 blue:51.0/255.0 alpha:0.9];
    }
    if (!_lineColor4FalseState) {
//        _lineColor4FalseState = [[UIColor colorWithRed:251.0/255.0 green:0 blue:11.0/255.0 alpha:0.9] retain];
        self.lineColor4FalseState = [UIColor colorWithRed:251.0/255.0 green:0 blue:11.0/255.0 alpha:0.9];
    }
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetShadow(context, CGSizeMake(1.0, 1.0), 1.0);
    UIColor *lineColor = _currentState?_lineColor:_lineColor4FalseState;
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextStrokePath(context);
}


#pragma mark - methods to handle event of touch move

- (void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, FALSE, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [self connect:startPoint toPoint:endPoint inContext:context];
    
    // use maskimageview to show the moving state
    
    _maskImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextSaveGState(context);
    UIGraphicsEndImageContext();
}


#pragma mark - public interface

- (void)resetInterface
{
    _currentState = normalState;
    _touchesEnabled = true;
    [self initLockView];
}

- (void)setCurrentState:(BOOL)currentState
{
    NSMutableArray *tempIndexs = [NSMutableArray arrayWithArray:_selectedIndexs];
    _currentState = currentState;
    [self initLockView];
    for (int i = 0; i< [tempIndexs count]; i++) {
        [self didSelectCircleAtIndex:[[tempIndexs objectAtIndex:i] intValue]];
    }
}

@end
