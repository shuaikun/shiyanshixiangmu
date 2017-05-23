//
//  ITTCommonMacros.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#ifndef iTotemFrame_ITTCommonMacros_h
#define iTotemFrame_ITTCommonMacros_h
////////////////////////////////////////////////////////////////////////////////
#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [ITTDataEnvironment sharedDataEnvironment]

#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions 

#define RELEASE_SAFELY(__POINTER) { if(__POINTER){[__POINTER release]; __POINTER = nil; }}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - iphone 5 / 6 detection functions

#define TABBAR_HEIGHT 49

#define SCREEN_HEIGHT_OF_IPHONE5 568

#define SCREEN_HEIGHT_OF_IPHONE6 667

#define is4InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE5)

#define is47InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE6)

#define OS_VERSION_AT_LEAST_7 floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1

////////////////////////////////////////////////////////////////////////////////
#pragma mark - degrees/radian functions 

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)

////////////////////////////////////////////////////////////////////////////////
#pragma mark - color functions 

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define SHOULDOVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}

#define IS_STRING_NOT_EMPTY(sting)    (sting && ![@"" isEqualToString:sting] && (NSNull *)sting!=[NSNull null])
#define IS_STRING_EMPTY(sting)        (!sting || [@"" isEqualToString:sting] || (NSNull *)sting==[NSNull null])
#define IsNull(obj)    ((obj==nil) || (obj && [obj isKindOfClass:[NSNull class]]))

#endif