//
//  KeyboardTextView.h
//  iTotemFramework
//
//  Created by Grant on 14-4-28.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KeyboardTextView : UIView

+ (KeyboardTextView*)instanceFromNib;

- (void)sendBtnDidClickedBlock:(void (^)(KeyboardTextView *keyboardTextView, NSString *text))block;
- (void)show;
- (void)hide;
- (void)clear;
- (void)destroy;
@end
