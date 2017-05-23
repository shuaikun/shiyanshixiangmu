//
//  SZLoginViewController.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLoginViewController : UIViewController
@property (nonatomic, readwrite) BOOL needHiddenBackBtn;

//注册和成功登录都会走这个方法
+ (void)loginSucessWithDictionary:(NSDictionary *)userInfo
                   viewController:(UIViewController *)viewController;
@end
