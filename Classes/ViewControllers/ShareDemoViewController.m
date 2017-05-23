//
//  ShareDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/12/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ShareDemoViewController.h"
#import "AppDelegate.h"
#import "SHKSina.h"
#import "SHKTencent.h"

@interface ShareDemoViewController ()

@end

@implementation ShareDemoViewController
#pragma mark - private methods
#pragma mark - lifecycle methods
- (id)init
{
    self = [super initWithNibName:@"ShareDemoViewController" bundle:nil];
    if (self) {
        self.navTitle = @"分享控件";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - public methods


- (IBAction)onShareToSinaBtnClicked:(id)sender
{
	if(_shkActionSheet.visible){
		[_shkActionSheet dismissWithClickedButtonIndex:-1 animated:NO];
	}
	if(_shkActionSheet){ RELEASE_SAFELY(_shkActionSheet); }
    
	//[SHK setRootViewController:self];
	SHKItem *itemToShare = [SHKItem itemFromDictionary:@{@"title": @"标题",
                                                    @"text": @"内容"}];

    itemToShare.image = [UIImage imageNamed:@"icon.png"];

	
	NSDictionary *items = @{@"SHKSina": itemToShare,
						   @"SHKTencent": itemToShare,
						   @"SHKMail": itemToShare};
	
	// Get the ShareKit action sheet
	_shkActionSheet = [[SHKActionSheet actionSheetForItems:items defaultItem:itemToShare] retain];
	
    //make sure window is on the top 
    //[[AppDelegate GetAppDelegate].window makeKeyAndVisible];
	// Display the action sheet
	[_shkActionSheet showInView:self.view];
}

- (IBAction)onLogoutSinaBtnClicked:(id)sender
{
    [SHKSina logout];
}

- (IBAction)onLogoutTencentBtnClicked:(id)sender
{
    [SHKTencent logout];
}
@end
