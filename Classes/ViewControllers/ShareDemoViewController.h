//
//  ShareDemoViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/12/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "BaseDemoViewController.h"
#import "SHKActionSheet.h"

@interface ShareDemoViewController : BaseDemoViewController{
	SHKActionSheet *_shkActionSheet;
}

- (IBAction)onShareToSinaBtnClicked:(id)sender;
- (IBAction)onLogoutSinaBtnClicked:(id)sender;
- (IBAction)onLogoutTencentBtnClicked:(id)sender;
@end
