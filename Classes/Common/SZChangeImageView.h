//
//  SZChangeImageView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol SZChangeImageViewDelegate <NSObject>

- (void)changeImageViewTakePictureButtonClicked;
- (void)changeImageViewChoosePictureButtonClicked;

@end

@interface SZChangeImageView : ITTXibView

@property (assign, nonatomic) id<SZChangeImageViewDelegate>delegate;

- (void)showInView:(UIView *)superView;

@end
