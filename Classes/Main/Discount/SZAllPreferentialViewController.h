//
//  SZAllPreferentialViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SZFilterView.h"

@interface SZAllPreferentialViewController : UIViewController<SZFilterViewDelegate>

@property (strong, nonatomic) IBOutlet SZFilterView * filterView;
@property (assign, nonatomic) BOOL isFromHomePage;

@end
