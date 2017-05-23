//
//  SZCityPickerViewController.h
//  iTotemFramework
//
//  Created by Grant on 14-5-6.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZCityPickerViewController : UIViewController
@property (nonatomic, weak) UIButton *cityPickerBtn;
@property (nonatomic, copy) void(^finishPickBlock)(NSString *city);
@end
