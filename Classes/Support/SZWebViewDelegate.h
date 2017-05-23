//
//  SZWebViewDelegate.h
//  iTotemFramework
//
//  Created by Grant on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZWebViewDelegate : NSObject
<UIWebViewDelegate>
//避免网页到网页的跳转进入嵌套循环 比如:跳朋友圈的新消息界面
@property (readwrite, nonatomic) BOOL isNestedHtmlRequest;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
- (void)loadRequestWithUrlString:(NSString *)urlString;
- (void)hideKeyboard;
@end
