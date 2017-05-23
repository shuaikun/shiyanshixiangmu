//
//  SZBaseTopView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol SZBaseTopViewDelegate <NSObject>

- (void)baseTopViewBackButtonClicked;
- (void)baseTopViewRightButtonClicked;
@end

@interface SZBaseTopView : ITTXibView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (assign, nonatomic) id<SZBaseTopViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)onBackButtonClicked:(id)sender;
- (IBAction)onRightButtonClicked:(id)sender;


@end

