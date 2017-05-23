//
//  SZLoginViewController.h
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLoginViewController : UIViewController
@property (nonatomic, readwrite) BOOL needHiddenBackBtn;

//注册和成功登录都会走这个方法
+ (void)loginSucessWithDictionary:(NSDictionary *)userInfo
                   viewController:(UIViewController *)viewController;
@end
