//
//  ITTMessageView.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/31/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@interface ITTMessageView : ITTXibView{
    int _disappearTime;
}

@property (assign, nonatomic) int disappearTime;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UIView *bgView;
+ (void)showMessage:(NSString*)msg;
+ (void)showMessage:(NSString*)msg disappearAfterTime:(int)time;
- (void)hide;
@end
