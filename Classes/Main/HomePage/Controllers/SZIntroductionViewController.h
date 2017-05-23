//
//  SZIntroductionViewController.h
//  iTotemFramework
//
//  Created by Grant on 14-5-4.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZIntroductionViewController : UIViewController
- (void)showIntroductionWithFinishBlock:(void(^)(void))finishBlock;
@end
