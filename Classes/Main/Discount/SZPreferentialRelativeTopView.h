//
//  SZPreferentialRelativeTopView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol SZPreferentialRelativeTopViewDelegate <NSObject>

- (void)preferentialRelativeTopViewBackButtonClicked;
- (void)preferentialRelativeTopViewShareButtonClicked;
- (void)preferentialRelativeTopViewShowPictureButtonClicked;

@end

@interface SZPreferentialRelativeTopView : ITTXibView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) id<SZPreferentialRelativeTopViewDelegate>delegate;

- (void)ifCoupon:(BOOL)isCoupon;
- (IBAction)onBackButtonClicked:(id)sender;
- (IBAction)onShareButtonClicked:(id)sender;
- (IBAction)onShowPictureButtonClicked:(id)sender;


@end
