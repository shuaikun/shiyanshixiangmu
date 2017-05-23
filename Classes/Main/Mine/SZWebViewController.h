//
//  SZWebViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-5-6.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"

@interface SZWebViewController : SZBaseViewController

@property (retain, nonatomic) NSString * topViewTitle;
@property (retain, nonatomic) NSString * urlStr;
@property (retain, nonatomic) NSString * htmlStr;
@property Boolean *is_url_request;

@end
