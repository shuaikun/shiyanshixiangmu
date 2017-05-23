//
//  ITTStatusBarMessageView.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/1/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@interface ITTStatusBarMessageView : ITTXibView

@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
- (void)showMessage:(NSString*)msg withDisappearTime:(int)disappearTime;
- (void)showMessage:(NSString*)msg;
- (void)hide;
@end
