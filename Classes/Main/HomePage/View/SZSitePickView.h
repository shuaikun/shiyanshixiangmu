//
//  SZSitePickView.h
//  iTotemFramework
//
//  Created by Grant on 14-5-8.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSitePickView : UIView
- (void)showSitePickViewWithFinishBlock:(void(^)(NSString *site))finishBlock;
@end
