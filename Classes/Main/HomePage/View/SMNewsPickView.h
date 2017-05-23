//
//  SMNewsPickView.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewsPickView : UIView
- (void)showNewsPickViewWithFinishBlock:(void(^)(NSString *news))finishBlock;
@end
