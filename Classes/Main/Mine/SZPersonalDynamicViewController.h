//
//  SZPersonalDynamicViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"

@interface SZPersonalDynamicViewController : UIViewController

@property (strong, nonatomic) NSString *name;
- (void)setupUrlWithUserId:(NSString *)userId isFriend:(BOOL)isFriend;
@end
