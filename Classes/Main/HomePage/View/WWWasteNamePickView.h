//
//  WWWasteNamePickView.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWasteNamePickView : UIView
- (void)showWasteNamePickViewWithFinishBlock:(void(^)(NSString *wastename))finishBlock;
@end
