//
//  WWPourWasteViewController.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-16.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "SZBaseViewController.h"
#import "Header_StaticDefine.h"

@interface WWPourWasteViewController : SZBaseViewController<UITextFieldDelegate>

@property (copy, nonatomic) NSString *symbolString;
@property (nonatomic, assign) NeedLogInOrNot login;

@end
