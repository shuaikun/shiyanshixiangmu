//
//  LockView.h
//  LockDemo
//
//  Created by 胡鹏 on 7/30/13.
//  Copyright (c) 2013 isoftStone. All rights reserved.
//

#define falseState FALSE;
#define normalState TRUE;


#import <UIKit/UIKit.h>


@class ITTLockView;

@protocol ITTLockViewDelegate <NSObject>

@optional

- (void)lockView:(ITTLockView *)lockView didSelectedCircleAtIndex:(NSInteger)index;

- (void)touchesEnd:(ITTLockView *)lockView;

@end

@interface ITTLockView : UIImageView

//
//@property (nonatomic, retain) UIImage *selectedImage;
//
//@property (nonatomic, retain) UIColor *lineColor;
//
//@property (nonatomic, retain) UIImage *selectedImage4FalseState;
//
//@property (nonatomic, retain) UIColor *lineColor4FalseState;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIImage *selectedImage4FalseState;

@property (nonatomic, strong) UIColor *lineColor4FalseState;

@property (nonatomic, assign) NSInteger lineWidth;

// 设置是否能跳点连接
@property (nonatomic, assign) BOOL canSkipConnect;

// 
//@property (nonatomic, retain) NSMutableArray *selectedIndexs;

@property (nonatomic, strong) NSMutableArray *selectedIndexs;

// 
@property (nonatomic, assign) id<ITTLockViewDelegate> delegate;

//
@property (nonatomic, assign) BOOL currentState;

//
@property (nonatomic, assign) BOOL touchesEnabled;


- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color circleThickness:(float)thickness circleFillColor:(UIColor *)fillColor;

- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color circleThickness:(float)thickness;

- (id)initWithFrame:(CGRect)frame circleRadius:(float)radius circleColor:(UIColor *)color;

- (void)resetInterface;


@end


