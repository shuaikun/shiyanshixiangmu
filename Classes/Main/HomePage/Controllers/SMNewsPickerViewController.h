//
//  SMNewsPickerViewController.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewsPickerViewController : UIViewController
@property (nonatomic, weak) UIButton *newsPickerBtn;
@property (nonatomic, copy) void(^finishPickBlock)(NSString *news);
@end