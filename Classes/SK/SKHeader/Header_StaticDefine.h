//
//  Header_StaticDefine.h
//  TheNewMothdNuzzle
//
//  Created by caoshuaikun on 2016/10/31.
//  Copyright © 2016年 com.yasuo.nuzzle. All rights reserved.
//

#ifndef Header_StaticDefine_h
#define Header_StaticDefine_h

#define Screen_Width [UIScreen mainScreen].bounds.size.width//屏幕宽
#define Screen_Height [UIScreen mainScreen].bounds.size.height//屏幕高

#pragma mark - 选择方法

//选择界面选择生日和性别
typedef enum : NSUInteger {
    selectBrith,//选择生日
    selectArrayMessge//选择自定义数组
} selectType;

typedef enum : NSUInteger {
    Need_Login,//需要登录
    NotNeed_Login//不需要登录
} NeedLogInOrNot;

#endif /* Header_StaticDefine_h */
