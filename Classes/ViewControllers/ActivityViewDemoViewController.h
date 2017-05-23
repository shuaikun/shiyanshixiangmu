//
//  ActivityViewDemoViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDemoViewController.h"
#import "ITTStatusBarWindow.h"
#import "ITTMaskActivityView.h"

@interface ActivityViewDemoViewController : BaseDemoViewController{
    UIButton *_selectedActivityBtn;
    ITTMaskActivityView *_maskActivityView;
}
@property (strong, nonatomic) IBOutlet UIButton *maskActivityBtn;
@property (strong, nonatomic) IBOutlet UIButton *statusBarActivityBtn;
- (IBAction)onMaskActivityBtnClicked:(id)sender;
- (IBAction)onStatusBarActivityBtnClicked:(id)sender;

@end
